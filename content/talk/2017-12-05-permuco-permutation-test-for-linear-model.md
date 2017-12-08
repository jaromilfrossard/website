+++
date = 2017-10-31T00:00:00  # Schedule page publish date.

title = "permuco : permutation test for linear model"
time_start = 2017-12-05T12:00:00
time_end = 2017-12-05T13:00:00
abstract = "presentation du package permuco"
abstract_short = "presentation du package permuco"
event = "RLunch"
event_url = "http://use-r-carlvogt.github.io/prochains-lunchs/"
location = "Geneva, Switzerland"

# Is this a selected talk? (true/false)
selected = true

# Projects (optional).
#   Associate this talk with one or more of your projects.
#   Simply enter the filename (excluding '.md') of your project file in `content/project/`.
projects = ["permuco"]

# Links (optional).
url_pdf = "pdf/2017_12_rlunchcarlvogt_permuco.pdf"
url_slides = ""
url_video = ""
url_code = "script/2017_12_rlunchcarlvogt_permuco.r"

# Does the content use math formatting?
math = true

# Does the content use source code highlighting?
highlight = true

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
[header]
image = ""
caption = ""

#Embed your slides or video here using [shortcodes](https://sourcethemes.com/academic/post/writing-markdown-latex/). Further details can easily be added using *Markdown* and $\rm \LaTeX$ math code.

+++

Contrairement aux principaux tests paramétriques, les tests de permutations permettent de s’affranchir de postulats sur la distribution des données et laissent un grand choix de statistique de test. Cependant, ils sont contraints à être utilisés pour des modèles simples (régression linéaire simple) et des méthodes de permutation ont été proposées afin d’étendre ces tests à des modèles plus complexes (régressions linéaires multiples). 

Ces tests ont trouvé un nouvel intérêt dans le cade d’expériences en neuroscience, notamment lors de l’utilisation de l’électroencéphalographie (EEG). Ces expériences nécessitent plusieurs centaines de tests statistiques et, utilisé conjointement à des méthodes de corrections pour tests multiples, les tests de permutations permettent de contrôler le taux d’erreur d’ensemble (FWER) tout garantissant une bonne puissance statistique. Ces méthodes peuvent être utilisée dans tout autre domaine où l'on veut comparer des signaux dans différentes conditions.

Nous verrons comment utiliser le package permuco (https://github.com/jaromilfrossard/permuco) afin d’obtenir des tests par permutations pour des modèles de régression,  d’ANOVA et d’ANCOVA, avec et sans mesures répétées. De plus, nous l’utiliserons pour comparer des signaux (en l’occurrence EEG) en utilisant des méthodes de corrections pour tests multiples tel que le "cluster-mass" ou le "TFCE".

 
