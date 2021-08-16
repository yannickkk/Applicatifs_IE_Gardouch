# Gardouch_suivi_sanitaire

Dump des schémas de db_gardouch qui nous intéressent
ici on crée un fichier db_gardouch.sql qu'on va ensuite dans une base de données locale (que l'on crée au préalable)

ma version de postgresl est la 12, remplace 12 par ton numéro de version et le chemin vers la sauvegarde

"C:\Program Files\PostgreSQL\12\bin\pg_dump.exe" --host pggeodb.nancy.inra.fr --port 5432 --username "jbelbouab"   --format plain --encoding UTF8 --verbose -O --file "C:\mon\chemin\vers\la\sauvegarde\db_gardouch.sql" -n "public" -n "main" -n "list" "db_gardouch"

Sur ton serveur localhost crée une base de données:

DROP DATABASE IF EXISTS db_gardouch;

CREATE DATABASE db_gardouch
             WITH OWNER = postgres
             ENCODING = 'UTF8'
             TEMPLATE template0
             TABLESPACE = pg_default
             LC_COLLATE = 'French_France.1252'
             LC_CTYPE = 'French_France.1252'
             CONNECTION LIMIT = -1;
-- ici je crée les roles qui existent dans la base sur el serveur

create ROLE gardouch_ecriture;
create ROLE gardouch_lecture;
create ROLE gardouch_admin;
create ROLE ychaval;

je charge l'extension tablefunc car j'utilise la fonction crosstab pour basculer les tables de long en large 
CREATE EXTENSION tablefunc
             SCHEMA public
			 
et ici on restore les données à partir de la sauvegarde
 
"C:\Program Files\PostgreSQL\12\bin\psql" -U "postgres" -d "db_gardouch" < "C:\mon\chemin\vers\la\sauvegarde\db_gardouch.sql"

tu risques d'avoir ce message d'erreur mais c'est pas grave:
ERREUR:  la relation Â« public.v_registre_gardouch Â» n'existe pas
