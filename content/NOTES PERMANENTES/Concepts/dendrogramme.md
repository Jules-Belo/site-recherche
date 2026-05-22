---
type: concept
tags: [concept, méthodologie, statistiques, visualisation, clustering]
sources: [Rein et al. (2010), Van Bergen et al. (2025)]
created: 2025-01-08
---
# Dendrogramme

Le **dendrogramme** constitue une représentation graphique hiérarchique des résultats d'un [[clustering hiérarchique]], prenant la forme d'un arbre binaire où chaque nœud représente la fusion successive de deux clusters en fonction de leur dissimilarité (Everitt et al., 2001). L'axe vertical du dendrogramme quantifie la hauteur de fusion, correspondant à la distance ou au degré de variance expliqué au moment où deux groupes sont agrégés, tandis que l'axe horizontal positionne les objets individuels (essais, participants, trajectoires) dans un ordre optimal minimisant les croisements visuels ([[Rein et al., 2010]]). Cette structure arborescente permet l'identification visuelle de clusters naturels par l'analyse des "sauts" dans les hauteurs de fusion : des augmentations abruptes signalent que la fusion de groupes très dissimilaires commence à s'opérer, suggérant que le nombre optimal de clusters se situe immédiatement avant ce seuil critique. La détermination formelle du seuil de coupure du dendrogramme s'appuie sur des critères statistiques complémentaires tels que le [[Score de Hubert-Γ]] ou les p-values du test approximately unbiased (AU test). Dans l'étude de [[Van Bergen et al. (2025)]] examinant les trajectoires d'escalade, l'analyse du dendrogramme a conduit à retenir un seuil de 15 unités de distance SSPD, permettant d'identifier des classes distinctes de solutions motrices tout en évitant une sur-segmentation artefactuelle du répertoire comportemental.

**Voir aussi** : [[clustering hiérarchique]] • [[méthode Ward]] • [[Score de Hubert-Γ]]
