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

![image](https://user-images.githubusercontent.com/39738426/125036197-06925600-e093-11eb-89f8-157cff14e39a.png)

*Une liste déroulante permet de choix d'un utilisateur parmis ceux enregistrés dans la base de données. Pour l'ajout d'un nouvel utilisateur demandez au gestionnaire SI. Ce champ est obligatoire pour pouvoir enregistrer une donnée.

N° de l'animal
Le numéro de l'animal est un **entier**. Il correspond au N° Inra de l'animal dans l'installation. Par défaut l'applicatif affiche le prochain numéro disponible pour saisir un nouvel individu entrant dasn l'installation. Ce champ est obligatoire et doit être unique.

Nom de l'animal
C'est un champ texte. La plupart des animaux présents dans l'installation ont un nom qui permet aux expérimentateurs de mieux individualiser les animaux. Cependant, historiquement, les animaux du grands enclos qui n'étaient pas soumis à des soins quotidien n'en possédaient pas. Afin d'harmoniser l'ensemble des données et pouvoir développer des applicatifs de saisie de terrain qui affichent les noms des animaux pour les utilisateurs, il a été décidé de rendre ce champ obligatoire. Ce champ prend donc par défaut la valeur "N° de l'animal_". Ce nom est libre mais doit être unique. Il peut être modifié à tout moment suivant besoins des utilisateurs.

![image](https://user-images.githubusercontent.com/39738426/125033795-0fcdf380-e090-11eb-93de-3538ba08a5b4.png)
En plaçant la souris sur la plupart des champs on obtient une aide sur la façon derenseigner le champ correspont
![image](https://user-images.githubusercontent.com/39738426/125038147-5c67fd80-e095-11eb-93d3-ff5b8eb2aede.png)
Ainsi lorsque l'on place la souris sur la zone de saisie de Nom, un phylactère d'affiche en dessous avec la mention "Le nom doit être unique"

Sexe


