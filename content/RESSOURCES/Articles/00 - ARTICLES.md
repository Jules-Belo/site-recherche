
**Avancement recherche bibliographique :** 

```dataview
TABLE WITHOUT ID 
file.link as "Fichier",
  authors as "Auteurs",
  year as "Année",
  status as "Statut",
  type_etude as "Type d'étude",
  approche as "Approche",
  discipline as "Discipline",
  citation as "Citation",
  choice(pdf, "📄 " + pdf, "—") as "PDF"
FROM "RESSOURCES/Articles"
WHERE file.name != "00 - Articles"
	AND !contains(file.name, "extraction")
SORT file.name ASC
```



- Hristovski, R., Davids, K., Araújo, D., & Passos, P. (2011). Constraints-induced emergence of functional novelty in complex neurobiological systems: A basis for creativity in sport. _Nonlinear Dynamics, Psychology, and Life Sciences_, _15_(2), 175–206. _(article déjà cité dans ta MOC mais pas de fiche dédiée)_
    
- Seifert, L., Wattebled, L., Herault, R., Poizat, G., Adé, D., Gal-Petitfaux, N., & Davids, K. (2014). Neurobiological degeneracy and affordance perception support functional intra-individual variability of inter-limb coordination during ice climbing. _PLoS ONE_, _9_(2), e89865. https://doi.org/10.1371/journal.pone.0089865 _(fiche existante mais vérifier la couverture du lien fatigue–variabilité)_

- Orth, D., van der Kamp, J., & Savelsbergh, G. J. P. (2018). Creativity in sport. In M. A. Runco & S. R. Pritzker (Eds.), _Encyclopedia of creativity_ (3rd ed., pp. 292–296). Academic Press. _(ou version article : vérifier ta fiche existante)_
    
- Davids, K., Button, C., & Bennett, S. (2008). _Dynamics of skill acquisition: A constraints-led approach_. Human Kinetics. _(cité dans ta MOC mais aucune fiche)_
    

- MacLeod, D., Sutherland, D. L., Buntin, L., Whitaker, A., Aitchison, T., Watt, I., Bradley, J., & Grant, S. (2007). Physiological determinants of climbing-specific finger endurance and sport rock climbing performance. _Journal of Sports Sciences_, _25_(12), 1433–1443. https://doi.org/10.1080/02640410600944550 _(fiche existante, mais vérifier couverture du protocole intermittent)_
    
- Giles, D., Chidley, J. B., Taylor, N., Torr, O., Hadley, J., Randall, T., & Fryer, S. (2019). The determination of finger-flexor critical force in rock climbers. _International Journal of Sports Physiology and Performance_, _14_(4), 473–480. https://doi.org/10.1123/ijspp.2018-0359 _(fiche existante — vérifier lien avec ton protocole 80% MVC)_
    