
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

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png)
image cette fonctionalité sera implémentée dans la V0.2. Acutellement tous les utilisateurs ont les droits d'écriture.

Certains champs sont obligatoires. Celà signifie que si ils ne sont pas remplis, on en peut pas enregistrer les informations saisies. Ces champs sont signalés par un astérisque ![image](https://user-images.githubusercontent.com/39738426/125034814-596b0e00-e091-11eb-8d1c-7e83ac4d02fe.png)

1- <h1> l'onglet Marquage/prélèvement/traitement </h1>

1.1- <h2> le formulaire de saisie </h2>

Le formumaire de saisie du premier onglet est composé de 4 sections: Identifiants, Marquage, Prélèvements, Comptages.

<h3> 1.1.1- Identifiants <h3/>

cette section regroupe l'ensemble des identifiants de l'opérateur de saisie et de la l'observation (la capture physique est un type d'observation. Une observation se caractérise par: un animal + une date)

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



2- Affichage des données, trie et export.

L'applicatif permet l'affichage, le trie et l'export de données.

L'affichage

Par défaut, l'ensemble des individus qui sont ou on étés présents dans l'unité expérimentale sont affichés.

Une case à coher permet de réduire cette sélection aux seuls animaux présents dasn l'installation.

image

Le trie

Le trie des données peut être réalisé de deux façon. La première consiste à saisir la valeur recherchée directement dans la cellule de recherche (voir l'exemple précédent).

La seconde consiste à utiliser les outils de sélection proposé par l'application en dessous de la zone de saisie. Ces outils varient en fonction du type de données. Par exemple dans un champ texte la recherche se fera par autocomplétion (donc par une saisie directe dasn le champ). Pour une valeur logique (vrai/faux) une liste déroulante s'affiche qui permet de sélectionner l'une ou l'autre des valeurs. Pour un entier ou une date c'est un outil de sélection de plage de valeurs qui s'affiche.

image

Les trie sont cumulatifs. Ainsi une peut créer des trie sur plusieurs champs simultanément. Ainsi si l'utilisateur souhaite savoir quels sont les males nés entre 2000 et 2005, il va dans un premier temps taper "M" ou "m" dans ani_sexe puis sélectioner la plage 2000-2001 dans ani_naissance_entier. Le résultat s'affiche alors.

image

image On peut réaliser un trie sur une plage de valeurs directement en saisissant la plage dans la zone de saisie avec le formalisme suivant pour l'exemple précédent: 2000 ... 2001 on obtiendra le même résultat que précédemment.

l'export

Enfin une fois les tries réalisés, le résultat peut être exporté dans plusieur format en cliquant simplement sur el format désiré:

image
