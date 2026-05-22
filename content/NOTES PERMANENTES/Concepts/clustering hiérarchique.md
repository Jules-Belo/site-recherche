---
type: concept
tags: [concept, méthodologie, statistiques, analyse-données]
sources: [Van Bergen et al. (2025), Besse et al. (2016)]
created: 2025-01-03
---

# Clustering hiérarchique

Le **clustering hiérarchique** constitue une méthode d'analyse statistique permettant de regrouper des observations en fonction de leur similarité, en construisant une hiérarchie de clusters emboîtés. Cette approche non supervisée ne nécessite pas de spécifier a priori le nombre de groupes à former, contrairement aux méthodes de partitionnement comme les k-means ([[Everitt et al., 2011]]).

Dans le contexte de l'étude de la [[créativité motrice]] en escalade, [[Van Bergen et al. (2025)]] utilisent le clustering hiérarchique pour regrouper les trajectoires de grimpeurs selon leur similarité spatiale. La métrique de distance employée est la [[distance segment-chemin symétrique]] développée par [[Besse et al. (2016)]], particulièrement adaptée à la comparaison de courbes fonctionnelles comme les trajectoires de mouvement.

Le résultat du clustering permet d'identifier des classes de trajectoires distinctes. L'[[originalité]] d'une trajectoire est ensuite calculée comme l'inverse de la prévalence de son cluster : une trajectoire appartenant à un cluster rare (peu de participants l'ayant exécutée) obtient un score d'originalité élevé. Cette opérationnalisation garantit que le critère d'originalité est évalué objectivement par rapport à l'ensemble du groupe de participants, et non subjectivement par des observateurs.

**Voir aussi** : [[distance segment-chemin symétrique]] • [[originalité]] • [[variabilité fonctionnelle]]
