# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'TecnicoSistemas'
copyright = '2024, Raul Vilchez'
author = 'Raul Vilchez'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = []

templates_path = ['_templates']
exclude_patterns = [
    '**/template.rst',
    '**/prueba-*.rst',
    '99_General/miscellaneous/planing_stim.rst',
    '99_General/miscellaneous/guestRequirements.rst',
    # Puedes excluir carpetas enteras de trabajo
    '01_Hardware/driver_development/drv_refs/cleanSlab.rst',
    '01_Hardware/hardware_resources/bus-map.rst',
    '01_Hardware/sistema/resume_modulo_0852.rst',
    '99_General/miscellaneous/newOrigin.rst'

]

# Branded icon
html_favicon = '_static/simulation.png'

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_extra_path = ['extra']

# -- Theme Options -----------------------------------------------------------

# See: https://sphinx-rtd-theme.readthedocs.io/en/latest/configuring.html
html_theme_options = {
    'analytics_id': '',  #  Provided by Google in your dashboard
    'analytics_anonymize_ip': False,
    'logo_only': False,
    # 'display_version': True,
    'prev_next_buttons_location': 'bottom',
    'style_external_links': False,
    'vcs_pageview_mode': '',
    'style_nav_header_background': '#2980B9',
    #"search_bar_text": "Search docs",
    # Toc options
    'collapse_navigation': True,
    'sticky_navigation': True,
    'navigation_depth': 4,
    'includehidden': True,
    'titles_only': False
}

# Custom CSS
html_css_files = [
    'css/theme.css',
]

# Custom JavaScript
html_js_files = [
    'js/theme.js',
]

