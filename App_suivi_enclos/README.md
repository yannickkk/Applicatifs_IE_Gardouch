# Gardouch_suivi_enclos
Applicatif client de bd_gardouch permettant **la visualisation** et **la mise à jour** des mouvements d'animaux au sein des parcs d'élevage de l'installation expérimentale de Gardouch.

## Fonctionnement de l'applicatif

![image](https://user-images.githubusercontent.com/39738426/121325887-4b02c880-c912-11eb-8cc2-84afbdbb4de5.png)
**Cet applicatif a été créé à partir du package  [Timevis](https://github.com/yannickkk/timevis)**

### Vue générale de l'applicatif

![image](https://user-images.githubusercontent.com/39738426/125275984-f804a280-e30f-11eb-9fec-7f87851e5659.png)
_Vue d'ensemble de la première page de l'application_ 

L'application comporte deux onglets, "Animaux" et "Enclos" (en haut de l'image ci-dessus à droite de IE Gardouch et ci-dessous).

![image](https://user-images.githubusercontent.com/39738426/125276104-1cf91580-e310-11eb-890d-53b26ca3ac65.png)
_Vue d'ensemble de la deuxième page de l'application_

Le premier onglet nommé **Animaux** permet d'afficher les mouvements de chaque animal au cours du temps et au travers des différents enclos de l'installation expérimentale.

Le second onglet nommé **Enclos** permet d'afficher au cours du temps les animaux présents dans chaque enclos de l'installation.

![image](https://user-images.githubusercontent.com/39738426/121325940-581fb780-c912-11eb-8717-5dbb6f530ad4.png) **Au lancement de l'applicatif, seuls les animaux dont la date de sortie est nulle dans le [registre](https://github.com/yannickkk/Applicatifs_IE_Gardouch/Gardouch_registre) de l'installation sont affichés car la case "Afficher seulement les animaux présent aujourd'hui" est par défaut cochée. Si on la décoche l'ensemble du mouvement des animaux élevés dans l'installation expérimentale de Gardouch s'affichent.**

![image](https://user-images.githubusercontent.com/39738426/121326804-2bb86b00-c913-11eb-92e6-171774dc68f7.png)

la liste déroulante "Utilisateur" permet à l'utilisateur de s'identifier.

![image](https://user-images.githubusercontent.com/39738426/121482086-143db880-c9cd-11eb-99fa-b56b05213851.png)

Evolution à venir: un controle utilisateur/mot de passe sera prochainement ajouté afin de transmettre les droits de l'utilisateur sur la base de données (appartenance au groupe lecture/écriture ou admin) 

La liste déroulante chevreuil(s) permet la sélection d'un animal en particulier

![image](https://user-images.githubusercontent.com/39738426/121481370-5a464c80-c9cc-11eb-859f-d6a0309fb551.png)

![image](https://user-images.githubusercontent.com/39738426/121325940-581fb780-c912-11eb-8717-5dbb6f530ad4.png) **attention si la case "Afficher seulement les animaux présent aujourd'hui" est cochée (cas par défaut), seuls les animaux encore présents actuellement dans l'installation s'affichent. Pour pouvoir sélectionner n'importe quel animal il faut penser à décocher cette case.**

<h2> Affichage du mouvement de la chevrette Fanny:</h2>

![image](https://user-images.githubusercontent.com/39738426/121327031-5f939080-c913-11eb-85f9-0babc00cf76f.png)

Le nom de l'animal est affiché dans la première colonne de la ligne de temps.

La barre rouge à droite symbolise le temps présent. Fanny est aujourd'hui (09/06/2021) dans l'enclos 9.

L'affichage permet de suivre les mouvements de Fanny au sein des enclos de l'installation. Ainsi Fanny a d'abord été placée dasn l'enclos 2b avant d'être déplacée dans les sous-enclos 4bc, puis 5a. L'enclos suivant est dasn l'affichage actuel impossible à lire car le temps de résidence à ce niveau de zoom ne permet pas l'affichage du label. Afin d'afficher le label, le niveau de zoon peut être changé à l'aide de la molette de la souris.

L'affichage peut être zoomé à l'aide la molette de la souris afin de faire apparaitre plus de détail.

![image](https://user-images.githubusercontent.com/39738426/121329133-370c9600-c915-11eb-9162-e6d743e8b17a.png)

On voit alors que Fanny est passé par l'enclos 2 en Octobre 2015 avant d'être cantonnée dans l'enclos 2 b.

Lorsque l'image est zommée il est possible de se déplacer dans la ligne de temps en faisant un clic gauche avec la souris et en déplaçant celle-ci dans le sens désiré. Le courseur de la souris prend alors la forme d'une croix:
![image](https://user-images.githubusercontent.com/39738426/121330421-4d672180-c916-11eb-97df-60d76bd5c0ff.png)

Le zoom peut permettre de voir que Fanny est entré dans l'IE de Gardouch le 1er Mai 2005 (on pourrait afficher l'heure si les données avaient ce niveau de précision, ici seul le jour est considéré).
![image](https://user-images.githubusercontent.com/39738426/121327771-0a0bb380-c914-11eb-9d51-4675b468e745.png)

![image](https://user-images.githubusercontent.com/39738426/121325887-4b02c880-c912-11eb-8cc2-84afbdbb4de5.png) **La base de données ne tolère pas qu'un individu soit dans deux enclos à la fois sauf le jour ou l'animal change d'enclos.**

<h2> changement d'enclos d'un animal </h2>

Tout d'abord un utilisateur et un animal doivent être sélectionner.

![image](https://user-images.githubusercontent.com/39738426/125275240-128a4c00-e30f-11eb-8843-ee9bff6c8827.png)

Une fois que l'on clique sur "Sélectionner des animaux" (i.e que l'on valide la sélection), l'interface change pour permettre la saisie des données:

![image](https://user-images.githubusercontent.com/39738426/125275280-203fd180-e30f-11eb-8843-1e6fa5fd393a.png)

Les champs suivant sont maintenant visibles:
Date de début
Date de fin
enclos
Remarque

Ils permettent d'assigner un nouvel enclos à un animal ou de modifier les données existantes.

<h3>Pour affecter l'animal à un nouvel enclos: </h3>


<h3>Pour modifier les données d'une affectation de l'animal: </h3>

