Cet applicatif sert à alimenter la base de données de l'installation expérimentale de Gardouch (db_gardouch).

Les tables alimentées par cet applicatif sont contenues dans le schéma main. Elles se nomment:

> t_individu_ind
>
> tj_individu_alpha_ai
>
> tj_individu_alpha_time_ati
>
> tj_individu_bool_bi
>
> tj_individu_bool_time_bti
>
> tj_individu_date_di
>
> tj_individu_integ_ii
>
> tj_individu_integ_time_iti
>
> tj_individu_num_ni
>
> tj_individu_num_time_nti

<h2 align="center">Vue général de l'applicatif registre.</h2>


![image](https://user-images.githubusercontent.com/39738426/125032324-16f40200-e08e-11eb-9c82-579477ce669d.png)

*L'applicatif se compose de deux partie: 1-le formulaire de saisie dans la partie supérieure; 2-l'affichage des données dans la partie inférieure.*

## 1- le formulaire de saisie

L'applicatif peut servir à la visualisation, au trie et à l'export des données (voir partie 2) ou a la saisie des données. Ces possibilités sont offertes aux utilisateurs en fonction du groupe auxquel ils appartiennent dans la base de données de Gardouch.

si l'utilisateur est membre du groupe Gardouch_lecture: seul la visualisation, le trie et l'export des données est autorisé.
si l'utilisateur est membre du groupe Gardouch_ecriture: l'édition des données est autorisée en plus de la visualisation, du trie et de l'export des données.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png)
 cette fonctionalité sera implémentée dans la V0.2. Acutellement tous les utilisateurs ont les droits d'écriture.
 
Certains champs sont obligatoires. Celà signifie que si ils ne sont pas remplis, on en peut pas enregistrer les informations saisies.
Ces champs sont signaléS par un astérisque ![image](https://user-images.githubusercontent.com/39738426/125034814-596b0e00-e091-11eb-8d1c-7e83ac4d02fe.png)

Le champ utilisateur:

![image](https://user-images.githubusercontent.com/39738426/125048776-8f63be80-e0a0-11eb-93fc-ba6a4566efe8.png)

*Une liste déroulante permet de choix d'un utilisateur parmis ceux enregistrés dans la base de données. Pour l'ajout d'un nouvel utilisateur demandez au gestionnaire SI. Ce champ est obligatoire pour pouvoir enregistrer une donnée.

**N° de l'animal**

Le numéro de l'animal est un **entier**. Il correspond au N° Inra de l'animal dans l'installation. Par défaut l'applicatif affiche le prochain numéro disponible pour saisir un nouvel individu entrant dasn l'installation. Ce champ est obligatoire et doit être unique.

**Nom de l'animal**

C'est un champ texte. La plupart des animaux présents dans l'installation ont un nom qui permet aux expérimentateurs de mieux individualiser les animaux. Cependant, historiquement, les animaux du grands enclos qui n'étaient pas soumis à des soins quotidien n'en possédaient pas. Afin d'harmoniser l'ensemble des données et pouvoir développer des applicatifs de saisie de terrain qui affichent les noms des animaux pour les utilisateurs, il a été décidé de rendre ce champ obligatoire. Ce champ prend donc par défaut la valeur "N° de l'animal_". Ce nom est libre mais doit être unique. Il peut être modifié à tout moment suivant besoins des utilisateurs.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png)
En plaçant la souris sur la plupart des champs on obtient une aide sur la façon de renseigner le champ correspondant.

![image](https://user-images.githubusercontent.com/39738426/125038147-5c67fd80-e095-11eb-93d3-ff5b8eb2aede.png)

*Ainsi lorsque l'on place la souris sur la zone de saisie de Nom, un phylactère d'affiche en dessous avec la mention "Le nom doit être unique"*

**Sexe**

Comme indiqué dans le phylactère correspondant, le sexe doit être renseigné par F, f, M ou m. Ce champ est obligatoire.

**Date naissance précise**

![image](https://user-images.githubusercontent.com/39738426/125038851-2f681a80-e096-11eb-8e44-1ba00403f456.png)

Ce champ permet de noter la date de naissance de l'animal si celle-ci est connue avec précision. Lorsque l'on clique sur cette zone un calendrier d'affiche pour permettre à l'utilisateur de choisir la date.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png)
Une saisie manuelle est possible au format aaaa-mm-jj

**Attention: la date de naissance ne peut être postérieure à la date d'entrée ni à la date de sortie.**

**Date naissance textuelle**

Champ texte. A utiliser si la date de naissance est approximatife exemple: "début Juin".

**Année de naissance**

Champ acceptant un entier. Année de naissance au format aaaa.

**De Gardouch?**

Case à cocher qui permet de savoir si l'animal est né à Gardouch ou si il vien de l'extérieur (valeur par défaut).

**Provenance**

Champ textuel obligatoire. Elevage ou localité d'origine si l'animal vient de l'extérieur, numéro de l'enclos de naissance si l'animal est né dans l'installation expériementale.

**Père et Mère**

Deux listes déroulantes qui contiennent respectivement tous les mâles et toutes les femelles de l'installation expériementale.

**Taille de la portée**

Nom de frères et soeurs de l'individu concerné.

**Espèce**

Champ obligatoire. Par défaut l'espèce est chevreuil car c'est actuellement la seule espèce élevée au sein de l'Installation Expériementale. 

**Date d'arrivée**

Champ Obligatoire car pour être saisi dans cet applicatif un animal doit être obligatoirement entré dasn l'installation. Comme pour les autres dates, un calendrier s'affiche lorsque l'on clique sur la zone de saisie.

**Date de départ**

Saisie d'une date de sortie de l'installation. 

**Attention cette date doit être postérieure à la date d'entrée**

**Code sortie**

Champ texte. Code de sortie utilisé par le zootechicien pour catégoriser l'évênement de sortie. 

**Date de mort**

Un calendrier s'affiche lorsque l'on clique sur la zone de saisie.

**Attention la date de mort ne peux pas être antérieure à la date d'arrivée ni à la date de départ.**

**Code Echant. genet**

Correspondance à le code utilisé en génétique (voir avec Joel Merlet).

**Code génotype**

Correspondance à le code du génotype (voir avec Joel Merlet).

**Remarque**

champ libre textuel.

**Code RFID**

code alphanumérique à 10 caractères correspondant au code transpondeurs TROVAN.

lorsque l'on souhaite ajouter des données ou modifier les données d'un animal existant, on peut afficher les données de l'animal en entrant sont numéro inra dans le champ N° de l'animal

Ainsi si l'on retre 211, les données de Quorine s'affichent  

![image](https://user-images.githubusercontent.com/39738426/125044722-88d34800-e09c-11eb-8cca-6fbc202cc4fb.png)

Elles peuvent être alors complétées puis enregistrée en cliquant sur Enregistrer:

ATTENTION: si le bouton Enregistrer est bleu pâle:

![image](https://user-images.githubusercontent.com/39738426/125045263-16169c80-e09d-11eb-8914-1b33d0ecdfc2.png)

Cela signifie qu'un champ obligatoire n'a pas été sasie (dans le cas du rappel d'un individu connu, il s'agit généralement du nom de l'utilisateur de l'applicatif).
Une fois tous les champ obligatoires remplis, l'enregistrement est autorisé et le bouton devient bleu foncé:

![image](https://user-images.githubusercontent.com/39738426/125047221-0c8e3400-e09f-11eb-8b00-1d9b41c07e64.png)

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png) Lorsque l'on en connait pas le N° de l'animal il est possible d'utiliser au préalable l'otuil d'affichage et de trie pour le connaitre. Si on connait le nom de l'animal "Quorine", taper ce nom dans l'encadré en dessous de ani_nom_registre permet de voit le numéro de l'animal dasn la colonne ani_n_inra.

![image](https://user-images.githubusercontent.com/39738426/125048372-2419ec80-e0a0-11eb-9033-311103460b50.png)

*lorsque "quori" est entré dans le champ ani_nom_registre, l'individu "Quorine" est sélectionné et le N° de l'animal se trouve dans ani_n_inra.*

## 2- Affichage des données, trie et export.

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

