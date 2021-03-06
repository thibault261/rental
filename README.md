# Rental

## Introduction
Calculates the mileage, the duration and the average speed of rentals from these positions (CSV format).

## Installation
### Prerequisites
- rails installed (I used Rails 4.0.13)
- ruby installed (I used Ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-linux])
- git installed (I used Git 2.7.4)
- postgres installed (i used PostgreSQL 9.3.13)

### Clone the repository
- Clone the project repository `git clone https://github.com/thibault261/rental.git`
- Change directory `cd rental`

### Install gem
- Install application gem by running `bundle install`

### Create postgres User
- Connect to postgres `sudo -u postgres psql` (your password will be asked)
- Create User 'rental' with his password `create user rental with password 'rental';`
- Allocates user rights `alter user rental superuser createrole createdb replication;`
- Then quit the postgres console `\q` 

### Init the application
- Create database `rake db:create`
- Make the migrations `rake db:migrate`

### Start the puma server
- Start with `rails s`

### Connect to home page
- Connect to this URL `http://localhost:3000/`
- That's it ! You can interact with the application

## Improvements & Optimizations
A défaut de temps pour réaliser tout ce que j'avais envisagé, j'ai repéré certaines améliorations que vous trouverez ci-dessous. En effet, j'ai axé mon travail afin d'être le plus précis et pertinent possible dans le calcul du kilométrage. J'ai testé pas mal de solutions avant de m'arrêter sur une qui reste perfectible. Nous aurons l'occasion d'en discuter plus longuement lors de mon prochain entretien.  

### User Interface
- Mettre un loader lors de l'upload du fichier CSV
- Afficher le tracé du trajet sur la page d'une location (Permet notamment de voir les erreurs de positionnement GPS, cf. plus bas) à l'aide de 'Maps JavaScript API' (https://developers.google.com/maps/documentation/javascript/?hl=fr)
- Ergonomie globale à améliorer

### Server

#### Performances
- Réduire le nombre de requêtes envoyées à 'Distance Matrix API'. On aurait pu passer par 'Direction API' (https://developers.google.com/maps/documentation/directions/intro?hl=fr#Waypoints) en envoyant en paramètre des coordonnées de waypoints/point de cheminements (23 au maximum), cependant cette API est "gourmande" en temps de calcul.

- Utiliser le gem 'em-http-request' (requêtes HTTP asynchrones, Keep-Alive, pipelining, ... ) plutôt que les thread pour gagner du temps lors des nombreux appel à 'Distance Matrix API' (https://developers.google.com/maps/documentation/distance-matrix/intro?hl=fr)

- Utiliser le gem 'delayed_job' afin d'exécuter en arrière-plan et de manière synchrone les tâches de creation de 'Rental'. Rapide à mettre en place côté serveur, mais il m'a manqué de temps pour faire une interface dédiée qui soit "propre".

#### Optimizations
- (Amélioration réalisée et présente dans la version actuelle) Utiliser 'Roads API' (https://developers.google.com/maps/documentation/roads/snap?hl=fr) afin d'affiner les points récupérés depuis le fichier CSV avant de les envoyer à 'Distance Matrix API'. En effet, il peut (et il y a dans les deux fichiers de tests) des erreurs de localisation liées à la précision de l'appareil GPS utilisé. On peut par exemple avoir un point (latitude/longitude) qui est signalé à 10 mètres de la position réelle du véhicule, le plaçant ainsi de l'autre côté de la route, dans l'autre sens. Si on conserve ce point lors des calculs avec l'API 'Distance Matrix', cela va fausser notre calcul du kilométrage.
Nous pourrons discuter des résultats obtenus avant optimisation et ceux obtenus après, il y a matière à réfléchir selon le jeu de données. 

#### Improvements
- Réaliser des tests avec les gem 'Rspec' et 'factory_girl' pour le model, le controller et le routing de Rental.
- Réaliser un script de déploiement automatique
- Gestion d'erreur plus fine (creation de classe d'erreur, etc ..)

## Note 
- J'utilise une clé gratuite afin de requêter les différentes API Google. Cette dernière limite le nombre de requêtes à 2500/jour. Si vous dépassez ce quota là (ce qui reviendrait à importer de très nombreuses fois les fichiers de tests), cela risque de ne plus marcher. Si tel est le cas, ou pour toutes autres questions, n'hésitez pas à me joindre à l'adresse suivante : thibault.martin30@gmail.com .

##### Thibault Martin
