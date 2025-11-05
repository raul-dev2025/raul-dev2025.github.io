Planing Structures - JSON to C Struct Translation Example
===========================================================

This document demonstrates how a JSON structure can be translated into dynamically allocated C structs.

Example JSON
------------

.. code-block:: json

    {
      "person": {
        "name": "John Doe",
        "age": 30,
        "is_student": false,
        "address": {
          "street": "123 Main St",
          "city": "Anytown",
          "zip_code": "12345"
        },
        "hobbies": ["reading", "gaming", "hiking"]
      }
    }

Equivalent C Structs
--------------------

Dynamic memory allocation is used for strings and variable-length arrays.

.. code-block:: c

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>

    // Address struct (dynamically allocated strings)
    typedef struct {
        char *street;
        char *city;
        char *zip_code;
    } Address;

    // Person struct (with dynamic hobbies array)
    typedef struct {
        char *name;
        int age;
        bool is_student;
        Address address;
        char **hobbies; // Dynamic array of strings
        int hobbies_count; // Track length
    } Person;

    // Root JSON object
    typedef struct {
        Person *person; // Nested dynamic allocation
    } JsonData;

Helper Functions
----------------

Memory management utilities:

.. code-block:: c

    // Free all allocated memory
    void free_json_data(JsonData *data) {
        if (data->person) {
            free(data->person->name);
            free(data->person->address.street);
            free(data->person->address.city);
            free(data->person->address.zip_code);

            for (int i = 0; i < data->person->hobbies_count; i++) {
                free(data->person->hobbies[i]);
            }
            free(data->person->hobbies);
            free(data->person);
        }
    }

    // Simulate JSON parsing
    Person* create_person(
        const char *name, int age, bool is_student,
        const char *street, const char *city, const char *zip_code,
        const char **hobbies, int hobbies_count
    ) {
        Person *p = malloc(sizeof(Person));
        p->name = strdup(name);
        p->age = age;
        p->is_student = is_student;

        p->address.street = strdup(street);
        p->address.city = strdup(city);
        p->address.zip_code = strdup(zip_code);

        p->hobbies = malloc(hobbies_count * sizeof(char*));
        p->hobbies_count = hobbies_count;
        for (int i = 0; i < hobbies_count; i++) {
            p->hobbies[i] = strdup(hobbies[i]);
        }

        return p;
    }

Example Usage
-------------

Populating the struct from simulated JSON data:

.. code-block:: c

    int main() {
        const char *hobbies[] = {"reading", "gaming", "hiking"};
        int hobbies_count = sizeof(hobbies) / sizeof(hobbies[0]);

        JsonData data;
        data.person = create_person(
            "John Doe", 30, false,
            "123 Main St", "Anytown", "12345",
            hobbies, hobbies_count
        );

        // Print data
        printf("Name: %s\n", data.person->name);
        printf("Age: %d\n", data.person->age);
        printf("Hobbies:\n");
        for (int i = 0; i < data.person->hobbies_count; i++) {
            printf(" - %s\n", data.person->hobbies[i]);
        }

        free_json_data(&data);
        return 0;
    }

Output
------

.. code-block:: text

    Name: John Doe
    Age: 30
    Hobbies:
      - reading
      - gaming
      - hiking

Key Features
------------

- **Dynamic Strings**: Uses ``strdup`` for flexible-length fields.
- **Variable-Length Arrays**: ``hobbies`` is allocated at runtime.
- **Memory Safety**: ``free_json_data`` prevents leaks.
- **Real-World Readiness**: Mimics parser behavior (actual JSON parsing would require a library like `cJSON`).

Next Steps
----------

To parse real JSON in C, integrate a library like `cJSON <https://github.com/DaveGamble/cJSON>`_.
