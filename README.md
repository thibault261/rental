# Rental

## Introduction
Calculates the mileage, the duration and the average speed of rentals from these positions (CSV format).

## Installation
### Prerequisites
- rails installed (i used Rails 4.0.13)
- ruby installed (i used Ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-linux])
- git installed (i used Git 2.7.4)

### Clone the repository
- Clone the project repository `git clone https://github.com/thibault261/rental.git`
- Change directory `cd rental`

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

## Improvements & Optimization
A défaut de temps pour réaliser tout ce que j'avais en tête, j'ai repéré certaines améliorations :

### User Interface
- Mettre un loader lors de l'upload du fichier CSV
- Afficher le tracé du trajet sur la page d'une location (Permet notament de voir les erreurs de positionnement GPS, cf. plus bas) à l'aide de 'Maps JavaScript API' (https://developers.google.com/maps/documentation/javascript/?hl=fr)
- Ergonomie globale à améliorer

### Server

#### Performances
- Utiliser le gem 'em-http-request' (requêtes HTTP asynchrones, Keep-Alive, pipelining, ... ) plutôt que les thread pour gagner du temps lors des nombreux appel à 'Distance Matrix API' (https://developers.google.com/maps/documentation/distance-matrix/intro?hl=fr)

- Utiliser le gem 'delayed_job' afin d'exécuter en arrière-plan et de manière synchrone les tâches de creation de 'Rental'. Rapide à mettre en place côté serveur, mais il m'a manqué de temps pour faire une interface dédiée qui soit "propre".

#### Optimizations
- Utiliser 'Roads API' (https://developers.google.com/maps/documentation/roads/snap?hl=fr) afin d'affiner les points récupérés depuis le fichier CSV avant de les envoyer à 'Distance Matrix API'. En effet, il peut (et il y a dans les deux fichiers de tests) des erreurs de localisation liées à la précision de l'appareil GPS utilisé. On peut par exemple avoir un point (latitude/longitude) qui est signalé à 10 mètres de la position réelle du véhicule, le plaçant ainsi de l'autre côté de la route, dans l'autre sens. Si on conserve ce point lors des calculs avec l'API 'Distance Matrix', cela va fausser notre calcul du kilométrage.


#### Improvements
- Réaliser des tests avec les gem 'Rspec' et 'factory_girl' pour le model, le controller et le routing de Rental.
- Réaliser un script de déploiement automatique

## Note 
- J'utilise une clé gratuite afin de requêter les différentes API Google. Cette dernière limite le nombre de requêtes à 2500/jour. Si vous dépassez ce quota là (ce qui reviendrait à importer de très nombreuses fois les fichiers de tests), cela risque de ne plus marcher. Si tel est le cas, ou pour toutes autres questions, n'hésitez pas à me joindre à l'adresse suivante : thibault.martin30@gmail.com .

##### Thibault Martin
