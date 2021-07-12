
Cet applicatif sert à alimenter la base de données de l'installation expérimentale de Gardouch (db_gardouch).

Les tables alimentées par cet applicatif sont contenues dans le schéma main. Elles se nomment:

>t_observation_obs
>
>tj_observation_alpha_aob
>
>tj_observation_alpha_time_atob
>
>tj_observation_bool_bob
>
>tj_observation_bool_time_btob
>
>tj_observation_integ_iob
>
>tj_observation_integ_time_itob
>
>tj_observation_num_nob
>
>tj_observation_num_time_ntob
>
>tj_observation_time_tob t_individu_ind

<h2 align="center"> Vue de la partie saisie du premier onglet de l'applicatif capture.</h2>


![image](https://user-images.githubusercontent.com/39738426/125062205-6ea26580-e0ae-11eb-9c05-5b54deb0b287.png)


Chacun des trois onglet de l'applicatif se compose de deux parties: 1-le formulaire de saisie dans la partie supérieure (lui même diisé en sections); 2-l'affichage des données dans la partie inférieure.

L'applicatif peut servir à la visualisation, au trie et à l'export des données (voir partie 2) ou a la saisie des données. Ces possibilités sont offertes aux utilisateurs en fonction du groupe auxquel ils appartiennent dans la base de données de Gardouch.

si l'utilisateur est membre du groupe Gardouch_lecture: seul la visualisation, le trie et l'export des données est autorisé. si l'utilisateur est membre du groupe Gardouch_ecriture: l'édition des données est autorisée en plus de la visualisation, du trie et de l'export des données.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png) cette fonctionalité sera implémentée dans la V0.2. Acutellement tous les utilisateurs ont les droits d'écriture.

Certains champs sont obligatoires. Celà signifie que si ils ne sont pas remplis, on en peut pas enregistrer les informations saisies. Ces champs sont signalés par un astérisque ![image](https://user-images.githubusercontent.com/39738426/125034814-596b0e00-e091-11eb-8d1c-7e83ac4d02fe.png)

<h1> 1- l'onglet Marquage/prélèvement/traitement </h1>

<h2> 1.1- le formulaire de saisie </h2>

Le formumaire de saisie du premier onglet est composé de 4 sections: Identifiants, Marquage, Prélèvements, Comptages.

<h3> 1.1.1- Identifiants </h3>

cette section regroupe l'ensemble des identifiants de l'opérateur de saisie et de l'observation (la capture physique est un type d'observation. Une observation se caractérise par: un animal + une date)

**Le champ utilisateur:**

![image](https://user-images.githubusercontent.com/39738426/125048776-8f63be80-e0a0-11eb-93fc-ba6a4566efe8.png)

*Une liste déroulante permet de choix d'un utilisateur parmis ceux enregistrés dans la base de données. Pour l'ajout d'un nouvel utilisateur demandez au gestionnaire SI. Ce champ est obligatoire pour pouvoir enregistrer une donnée.

**N°invariant animal**

Le numéro de l'animal est un entier. Il correspond au N° Inra de l'animal dans l'installation. Par défaut l'applicatif affiche 0 qui ne correspond à aucun animal de l'installation. Ce champ est obligatoire puisqu'une observation (capture) est défini par un individu et une date.

**Nom**

C'est une liste de choix qui comporte une option d'autocomplétion. On peut donc rechercher un animal dans la liste ou entrer le début de son nom afin de réduire la sélection.

![image](https://user-images.githubusercontent.com/39738426/125064780-4b2cea00-e0b1-11eb-991e-8f2f7a1fd9d2.png) 

*En plaçant la souris sur la plupart des champs on obtient une aide sur la façon de renseigner le champ correspondant.*

**Code RFID**

code alphanumérique à 10 caractères correspondant au code transpondeurs TROVAN.

**Date de capture**

![image](https://user-images.githubusercontent.com/39738426/125065061-a6f77300-e0b1-11eb-9e03-9bdd681f3582.png)

Ce champ permet de renseigner la date de capture de l'animal. Lorsque l'on clique sur cette zone un calendrier d'affiche pour permettre à l'utilisateur de choisir la date de la capture.

Une fois les champs obligatoires remplis (utilisateur, numéro de l'animal, nom et date de capture il est possible de créer une capture

**ATTENTION:** si le bouton Créer la capture est bleu pâle:

![image](https://user-images.githubusercontent.com/39738426/125065664-60eedf00-e0b2-11eb-8931-dbdfa1abe1b6.png)

Cela signifie qu'un champ obligatoire n'a pas été sasie. Une fois tous les champ obligatoires remplis, la création de la capture est autorisé et le bouton devient bleu foncé:

![image](https://user-images.githubusercontent.com/39738426/125065738-7c59ea00-e0b2-11eb-97bd-1ca5cec78cca.png)

<h2> 1.1.2- Marquage </h2> 

Lors d'une capture un animal peut être ou non équipé d'un collier de marquage et.ou de suivi (capteurs embarqués).

**Collier**

Ce champ est un champ textuel permettant de décrire le collier dont est équipé l'animal (c'est le champs qui sera afficher à titre d'aide à la reconnaissance par l'applicatif de suivi_sanitaire).

1.1.3- Prélèvements

C'est un ensemble de 4 listes déroulantes qui permettent de saisir l'ensembl des prélèvements réalisés sur un animal. A chaque prélèvement est assicié un nombre d'échantillons prélevés. Chaque échantillon prélevé peut faire l'objet d'une remarque textuelle libre.

1.1.3- Comptges

Un menu déroulant permet de renseigner le nombre de chaque taxon de parasite rescencés dans la liste déroulante "Parasites".
Pour les données de présences/abscences, l'opérateur utilisera les cases à cocher.
Deux champ libres permettent de renseigner les blessures et traitements appliqués.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png) cette section est à améliorer. Ainsi dasn la version V2.0 Les champs traitant de l'état des bois, de la gestation et de la diarrhée apparaitront dans une section propre.

1.1.3- Anesthésie

Permet de décrire les produits utilisés pour l'anesthésie ainsi que les heures d'anesthésie et de réveil. Les doses de produits sont décrites en détail sur l'applicatif [Sicpa sanitaire](https://forge-dga.jouy.inra.fr/projects/sicpa-sanitaire-web)

<h2> 1.2- l'affichage des données </h2>

L'applicatif permet l'affichage, le trie et l'export de données.

**L'affichage**

Par défaut, l'ensemble des individus qui sont ou on étés présents dans l'unité expérimentale sont affichés.

Une case à coher permet de réduire cette sélection aux seuls animaux présents dasn l'installation.

![image](https://user-images.githubusercontent.com/39738426/125049251-131dab00-e0a1-11eb-86ca-cae5424a2b92.png)

**Le trie**

Le trie des données peut être réalisé de deux façon. La première consiste à saisir la valeur recherchée directement dans la cellule de recherche (voir l'exemple précédent).

La seconde consiste à utiliser les outils de sélection proposé par l'application en dessous de la zone de saisie. Ces outils varient en fonction du type de données. Par exemple dans un champ texte la recherche se fera par autocomplétion (donc par une saisie directe dasn le champ).
Pour une valeur logique (vrai/faux) une liste déroulante s'affiche qui permet de sélectionner l'une ou l'autre des valeurs.
Pour un entier ou une date c'est un outil de sélection de plage de valeurs qui s'affiche.

![image](https://user-images.githubusercontent.com/39738426/125054881-f4baae00-e0a6-11eb-9f9e-1070d1aff9ca.png)

Les trie sont cumulatifs. Ainsi une peut créer des trie sur plusieurs champs simultanément. Ainsi si l'utilisateur souhaite savoir quels sont les males nés entre 2000 et 2005, il va dans un premier temps taper "M" ou "m" dans ani_sexe puis sélectioner la plage 2000-2001 dans ani_naissance_entier. Le résultat s'affiche alors.

![image](https://user-images.githubusercontent.com/39738426/125055572-a063fe00-e0a7-11eb-93c4-ffdc1fbeaec9.png)

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png) On peut réaliser un trie sur une plage de valeurs directement en saisissant la plage dans la zone de saisie avec le formalisme suivant pour l'exemple précédent: 2000 ... 2001 on obtiendra le même résultat que précédemment.

**l'export**

Enfin une fois les tries réalisés, le résultat peut être exporté dans plusieur format en cliquant simplement sur el format désiré:

![image](https://user-images.githubusercontent.com/39738426/125056087-2d0ebc00-e0a8-11eb-9acc-81cb1e14998a.png)

<h1> 2- Les mesures </h1>

<h2> 2.1- le formulaire de saisie </h2>

Le formumaire de saisie du deuxième onglet est composé de 5 sections: Poids, heures et durées, Mensurations, Mesures ponctuelles, Mesures répétées.

![image](https://user-images.githubusercontent.com/39738426/125269475-056a5e80-e309-11eb-9034-823904ed62cd.png)
*vue d'ensemble du formulaire de saisie du second onglet de l'application*

<h3> 2.1.1- Le poids </h3>

Le poids peut être entré directement dans le cas ou l'animal passe seul sur une balance. Dans ce cas on ne sélectionne pas de numéro de sabot dans le premier menu déroulant et on sélectionne "poids_animal" dasn el second menu déroulant, on entre ensuite la valeur du poids au format numérique. Une remarque peut être ajoutée.

Le poids peut être déduit du poids de la boite de contention (pleine - vide) appelée un sabot. Ainsi on peut choisir dans la première liste déroulante le numéro du sabot qui contient l'animal (écrit au marqueur sur celui-ci) et entrer successivement le poids du "sabot_plein" et le poids du "sabot_vide", le poids de l'animal sera automatiquement entré dasn la base de données. 

<h3> 2.1.2- Les heures et durées </h3>

une liste déroulante permet de choisir l'heure ou la durée à saisir.

![image](https://user-images.githubusercontent.com/39738426/125269140-b6bcc480-e308-11eb-9c51-714c1f39604a.png)

*ensemble des heures et durées qui peuvent être saisies.*

On entre ensuite une heure dans les champs heure et minutes et une remarque éventuelle dans el champ textuel remarque.

<h3> 2.1.3- Les Mensurations </h3>

![image](https://user-images.githubusercontent.com/39738426/125270059-993c2a80-e309-11eb-9ba5-b70884d8cd28.png)
*Une liste déroulante permet de choisir de choisir une mesure*

Dès qu'une valeur est entrée pour une mesure, celle-ci est entrée dans la base de données.

<h3> 2.1.4- Les Mesures ponctuelles </h3>

Certaines mesures font l'objet d'une dénomination de variable dans la base données. A une valeur correspond une et une seule mesure. C'est le cas de cardio_20s_1, cardio_20sec_2, cardio_20sec_3. Ses données peuvent être associées à une heure ou non.

Si on veut effectuer plus de trois mesure du rythme cardiaque, on utilisera les mesures répétées ou suiiv du rythme cardiaque décrit dans al section suivant.

<h3> 2.1.5- Les Mesures répétées </h3>

Une mesure peut être répétée une infinité de fois, ainsi le rythme cardiaque peut être suivi tout au long de a capture (monitoring), on sélectionnera alors pour cet exemple le suivi "rythme_cardiaque" dans le premier menu déroulant puis on entrera une valeur et une heure au format hh:mm:ss pour chacune de ses valeurs. Une remarque pourra être associée à chaque mesure.

<h2> 2.2- l'affichage des données </h2>

Voir la section [1.2- l'affichage des données](#-12--laffichage-des-donn%C3%A9es-)

<h1> 3- Le comportement </h1>

Le formumaire de saisie du deuxième onglet est composé de 4 sections décrivant le comportement: au filet, dans le sabot, sur la table, au lâché

![image](https://user-images.githubusercontent.com/39738426/125269641-3054b280-e309-11eb-9f3b-7fb9d2c7d85f.png)
*vue d'ensemble du formulaire de saisie du troisième onglet de l'application*

<h2> 3.1- le formulaire de saisie </h2>

<h3> 3.1.1- Comportement au filet </h3>

![image](https://user-images.githubusercontent.com/39738426/125271208-c937fd80-e30a-11eb-86c5-4b5b7e1c7693.png)

Le comportement au filet est sélectionné parmis une liste déroulante  

![image](https://user-images.githubusercontent.com/39738426/125271379-f84e6f00-e30a-11eb-813f-765f5731c9bd.png)

Et une valeur (ici un boléen) lui est affecté.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png) les listes de valeurs dépendent du choix qui est fait dasn la première liste déroulante.

![image](https://user-images.githubusercontent.com/39738426/125271509-20d66900-e30b-11eb-8df5-13c9cf74a992.png)
*ainsi lorsque cri est sélectionné la valeur n'est plus un boléen mais un nombre de cri.*

<h3> 3.1.2- Comportement dans le sabot </h3>

![image](https://user-images.githubusercontent.com/39738426/125271831-73178a00-e30b-11eb-93fd-29ec7076c561.png)

Une liste de comportement permet de sélectionner le comportement souhaité auquel on affecte une valeur. Une remarque et el nom de la personne qui observe le comportement peut être ajouté. 

<h3> 3.1.3- Comportement sur la table </h3>

![image](https://user-images.githubusercontent.com/39738426/125272037-ab1ecd00-e30b-11eb-9a12-12736a746215.png)

Le fonctionnement est le même que pour el comportement en sabot.

<h3> 3.1.4- Comportement au lâché </h3>

![image](https://user-images.githubusercontent.com/39738426/125272108-c25dba80-e30b-11eb-842c-89e0e1c6d030.png)

Le fonctionnement est le même que pour el comportement en sabot.

Des informations complémentaire au lâcher peuvent être sasie comme la visibilité, le nombre d'arrêt que réalise l'animal avant de disparaitre et le nombre de personnes présentent lors du lâcher.

<h2> 3.2- l'affichage des données </h2>

Voir la section [1.2- l'affichage des données](#-12--laffichage-des-donn%C3%A9es-)
