# Protectedareas_deforestation
Patrick Selänniemi 
University of Helsinki, 2023

This public GitHub repisitory contains code I have written for my Masters thesis at the University of Helsinki in spring 2023.The data is structured in such a way that all GIS processing is done in the Google Earth Engine (this code will be linked in a EARTH ENGINE file), data exploration and data structuring is done in python in jupyter notebooks and finally all data analysis is done in R Studio. Anyone accessing this repository should be able to repeat the study running all the code in this repository (if problems or questions arise you can contact me at patrick.selanniemi@helsinki.fi).


The datasets im using are forest cover and deforestation data with a 50% canopy cover threshold (i.e. ≥50% of the raster pixel has to be covered in vegetation over 5m in height for it to count as forested), and polygons on the worlds protected areas. I have used corruption perception indexes as a proxy for governance level and GDP as a proxy for development in a country. 

It is worth noting that we are using 3 different coding languages and I'm a biologist at heart, not a data scientist so the code is at times not optimized.


The datasets used for this analysis are:

- Deforestation and forest cover: Hansen, M. C., P. V. Potapov, R. Moore, M. Hancher, S. A. Turubanova, A. Tyukavina, D. Thau, S. V. Stehman, S. J. Goetz, T. R. Loveland, A. Kommareddy, A. Egorov, L. Chini, C. O. Justice, and J. R. G. Townshend. 2013. “High-Resolution Global Maps of 21st-Century Forest Cover Change.” Science 342 (15 November): 850–53. Data available on-line from: https://glad.earthengine.app/view/global-forest-change.


- Protected area increases and protected area coverage: UNEP-WCMC and IUCN (year), Protected Planet: The World Database on Protected Areas. Available at: www.protectedplanet.net. and https://developers.google.com/earth-engine/datasets/catalog/WCMC_WDPA_current_polygons


- Funding data for conservation from: Waldron, Anthony, et al. "Targeting global conservation funding to limit immediate biodiversity declines." Proceedings of the National Academy of Sciences 110.29 (2013): 12144-12148.


- Corruption scores from Transparency International: https://www.transparency.org/en/


- Gross Domestic Product (GDP) data: https://data.worldbank.org/indicator/NY.GDP.MKTP.CD

- Purchasing Power Parity (PPP) data: https://data.oecd.org/conversion/purchasing-power-parities-ppp.htm

