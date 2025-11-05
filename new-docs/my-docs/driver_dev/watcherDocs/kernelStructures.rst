Linux Kernel-Style JSON Struct Example
=====================================

Principles
----------
1. **No object-specific allocators**: Avoid functions like ``create_person()``.
2. **Generic memory allocation**: Use ``kmalloc()``/``kzalloc()``.
3. **Direct struct initialization**: No constructors; fields are set directly.
4. **Fixed-size buffers**: Prefer ``char[NAME_LEN]`` over dynamic strings.
5. **Error codes**: Return ``-ENOMEM`` or ``-EINVAL`` instead of aborting.

Struct Definitions
-----------------
.. code-block:: c

    #include <linux/types.h>
    #include <linux/slab.h>
    #include <linux/string.h>

    #define NAME_LEN 50
    #define HOBBY_LEN 20
    #define MAX_HOBBIES 10

    struct address {
        char street[NAME_LEN];
        char city[NAME_LEN];
        char zip_code[10];
    };

    struct person {
        char name[NAME_LEN];
        int age;
        bool is_student;
        struct address addr;
        char hobbies[MAX_HOBBIES][HOBBY_LEN];
        int hobbies_count;
    };

    struct json_data {
        struct person *person;
    };

Memory Allocation
----------------
.. code-block:: c

    struct person *person_alloc(void)
    {
        return kzalloc(sizeof(struct person), GFP_KERNEL);
    }

    void person_free(struct person *p)
    {
        kfree(p);
    }

Data Initialization
------------------
.. code-block:: c

    int person_set_name(struct person *p, const char *name)
    {
        if (!p || !name)
            return -EINVAL;
        
        strscpy(p->name, name, NAME_LEN);
        return 0;
    }

    int person_add_hobby(struct person *p, const char *hobby)
    {
        if (!p || !hobby || p->hobbies_count >= MAX_HOBBIES)
            return -EINVAL;
        
        strscpy(p->hobbies[p->hobbies_count], hobby, HOBBY_LEN);
        p->hobbies_count++;
        return 0;
    }

Example Usage
------------
.. code-block:: c

    int example_init(void)
    {
        struct json_data data;
        struct person *p;
        int err;

        p = person_alloc();
        if (!p)
            return -ENOMEM;

        err = person_set_name(p, "John Doe");
        if (err)
            goto fail;

        p->age = 30;
        p->is_student = false;

        strscpy(p->addr.street, "123 Main St", NAME_LEN);
        strscpy(p->addr.city, "Anytown", NAME_LEN);
        strscpy(p->addr.zip_code, "12345", 10);

        person_add_hobby(p, "reading");
        person_add_hobby(p, "gaming");

        data.person = p;
        return 0;

    fail:
        person_free(p);
        return err;
    }

Key Differences from Userspace
-----------------------------
- Uses ``kzalloc()`` instead of ``malloc()``.
- No ``strdup``; fixed buffers with ``strscpy()``.
- Initialization is explicit (no constructors).
- Error handling via return codes (``-EINVAL``, ``-ENOMEM``).

Dynamic Sizes (Advanced)
-----------------------
For variable-length data, the kernel would:

1. Use ``struct list_head`` for linked lists.
2. Implement reference counting with ``kref``.

.. code-block:: c

    struct hobby {
        char name[HOBBY_LEN];
        struct list_head list;
    };

    struct person {
        // ...
        struct list_head hobbies; // Dynamic list
    };
