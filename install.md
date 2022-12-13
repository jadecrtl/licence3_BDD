=========================== 
Commandes de bases de psql
=========================== 

Démarrer : psql

Quitter : \q

Lister le contenu du répertoire courant : \! ls

Changer de répertoire (se déplacer dans le dossier TP1 par exemple) : \cd TP1

Exécuter un fichier sql se trouvant dans le répertoire courant (c'est à dire qui 
est visible lorsqu'on fait \! ls) : \i TP1.sql

Si le fichier TP1.sql que vous voulez charger n'est pas dans le répertoire
courant, vous pouvez soit vous déplacer dans ce répertoire avec la commande
\cd expliquée plus haut, soit entrer le chemin complet. Par exemple, si je suis
dans un répertoire qui contient TP1 et que TP1 contient TP1.sql, je fais soit :
  \i TP1/TP1.sql
soit je me déplace dans TP1 avant d'exécuter le fichier :
  \cd TP1
  \i TP1.sql

Au lieu d'entrer vos requêtes dans le terminal, il faut mieux les mettre
dans un fichier TP1_sol.sql par exemple, puis exécuter le fichier dans psql :
  \i TP1_sol.sql

Si vous ne voulez pas que tout le fichier TP1_sol.sql soit exécuté (par exemple
vous ne voulez plus voir s'afficher les réponses aux questions que vous avez déjà 
résolues), il suffit d'entourer tout le bloc de texte dans TP1_sol.sql à faire
disparaitre par /* et */
  
Afficher les tables en mémoire : \dt
  
Afficher des informations sur une table "maTable" : \d+ maTable
  
Supprimer toutes les tables en mémoire :
  drop schema public cascade;
  create schema public;

=============================== 
Installer PostgreSQL sur Linux
=============================== 

Commencez par installer le package, en entrant dans le terminal :
  sudo apt-get install postgresql
Il faudra confirmer l'installation à un moment en entrant Y (ou O).

Une fois installé, psql doit être configuré. Pour cela, entrez :
  sudo -u postgres createuser -s $(whoami); createdb $(whoami)

Si l'installation s'est bien passée, vous pouvez maintenant démarrer
psql comme en TP, en entrant simplement :
  psql

En cas de problème pendant l'installation vous pouvez regarder ici :
  https://doc.ubuntu-fr.org/postgresql
ou rechercher votre message d'erreur sur internet pour avoir de l'aide.

============================================
Installer Ubuntu dans une machine virtuelle
============================================

Si votre ordinateur n'a pas de système linux, vous pouvez installer Ubuntu dans
une machine virtuelle qui pourra être démarrée comme un logiciel normal depuis
Windows (vous aurez Ubuntu qui fonctionnera "à l'intérieur" de Windows).

Pour cela, il faut d'abord installer le logiciel virtual box (dans windows), 
disponible ici : 
  http://download.virtualbox.org/virtualbox/5.1.28/VirtualBox-5.1.28-117968-Win.exe

Il faut également télécharger ubuntu (fichier au format .iso) : 
  https://ubuntu-fr.org/telechargement?action=dl

Vous pouvez ensuite suivre les instructions ici : 
  https://openclassrooms.com/courses/reprenez-le-controle-a-l-aide-de-linux/installez-linux-dans-une-machine-virtuelle
pour procéder à l'installation. Pas d'inquiétude lorsqu'il y aura un message 
indiquant que tous vos fichiers seront supprimés (la machine virtuelle est 
séparée de votre système windows, elle ne modifiera rien sur votre ordinateur). 
Il est fortement recommandé de faire également l'installation des additions 
invités (expliqué dans le lien + haut), pour qu'ubuntu s'exécute plus rapidement.

Une fois qu'ubuntu est installé, vous pouvez ajouter emacs par exemple, en entrant
dans le terminal d'ubuntu :
  sudo apt-get install emacs

Si votre ordinateur n'est pas très puissant, ubuntu peut avoir du mal à fonctionner dans
windows. Dans ce cas, il faut plutôt faire une installation en dual boot sur une autre 
partition du disque dur, mais c'est plus compliqué... (se renseigner sur internet).

==================================
Installer PostegreSQL sous Windows
==================================

Il est possible d'installer psql sous windows, puis de l'utiliser depuis le terminal
Windows. Pour cela, commencez par télécharger et installer : 
  https://www.enterprisedb.com/downloads/postgres-postgresql-downloads#windows
choisissez la dernière version disponible de psql, et la version de votre système
windows (32 ou 64 bits). Si vous ne savez pas quelle est la version de votre windows,
regardez ici :
  https://support.microsoft.com/fr-fr/help/827218/how-to-determine-whether-a-computer-is-running-a-32-bit-version-or-64

Une fois l'installation terminée, il va falloir modifier les variables d'environnement
pour que votre ordinateur sache où se trouve psql. Pour cela, il faut ouvrir la boite
de configuration "Modifier les variables d'environnement système". Normalement, ça se 
trouve facilement en entrant les mots "variables" et "système" dans la recherche de 
programme windows (en cliquant tout en bas à gauche de l'écran). 
Cliquez ensuite sur "Variables d'environnement" dans la fenêtre qui s'est ouverte, puis 
chercher la variable "Path" parmi les variables utilisateurs. Cliquez sur modifier, puis 
ajoutez (dans le champ "Valeur de la variable") :
  C:\Program Files\PostgreSQL\9.6\bin;C:\Program Files\PostgreSQL\9.6\lib
Attention :
 - si le champs "Valeur de la variable" était déjà rempli, il ne faut pas le supprimer mais
   ajouter à la suite en mettant d'abord un ;
 - il ne faut pas d'espace entre les ;
 - il est possible que psql ait été installé à un endroit différent de votre ordinateur (ou
   avec autre chose que 9.6 si vous avez une autre version). Essayez de trouver cet endroit
   par vous-même puis modifiez les chemins ci-dessus (par exemple remplacer C: par D: si votre
   disque s'appelle D:)
   
Si tout s'est bien passé, vous pouvez ouvrir le terminal windows (en entrant cmd dans le 
champ de recherche des programmes windows) puis taper (attention c'est un U majuscule) :
  psql -U postgres
et obtenir une demande de mot de passe (si l'installation a un problème, il vous dira qu'il 
ne connait pas psql...). Entrez le mot de passe choisi lors de l'installation, puis créez 
votre utilisateur et votre base de donnée :
  CREATE USER bob WITH ENCRYPTED PASSWORD '1234';
  CREATE DATABASE bob OWNER bob;
Quittez ensuite avec \q

Vous pouvez maintenant utiliser psql normalement en entrant dans le terminal windows :
  psql -U bob

Attention, il y a plusieurs commandes différentes sous Linux et Windows. Par exemple :
  \! dir
au lieu de 
  \! ls
Mais vous pouvez toujours vous déplacer dans psql avec \cd


=================================================================
Installer PostegreSQL sous Mac
=================================================================
Les deux solutions les plus simples :
- en installant postgresapp, c.f. https://postgresapp.com/documentation/install.html 
- avec le gestionnaire de paquets homebrew, c.f. https://wiki.postgresql.org/wiki/Homebrew


=================================================================
Installer PostegreSQL sous Windows ou Mac dans un container dédié
=================================================================

Autre alternative, installer Postgres dans une container dédié sous Windows ou Mac
(ce qui permet notamment de le désinstaller plus facilement). Vous pouvez vous renseigner
ici :
  https://docs.docker.com/kitematic/userguide/
  
Attention, ça ne marchera pas si votre système windows est en 32 bits.

