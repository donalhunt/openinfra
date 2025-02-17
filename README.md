
<!-- badges: start -->

[![R-CMD-check](https://github.com/udsleeds/openinfra/workflows/R-CMD-check/badge.svg)](https://github.com/udsleeds/openinfra/actions)
<!-- badges: end -->

# Open access data for transport research: tools, modelling and simulation

# Summary

Getting people walking and cycling has become a priority for many local,
regional and national governments in recent years. Interventions
boosting physical activity represent a ‘magic bullet’, tackling obesity,
air pollution and wellbeing. Active travel is a rapidly growing topic of
multi-disciplinary research but has received limited attention from data
science perspectives, with a recent paper on modelling cycle network
growth (Orozco et al. 2020) providing a notable exception. The work will
be grounded in geographic data science, building on previous studies
assessing open datasets for transport applications (Ferster et al. 2020;
Haklay 2010).

In the post-pandemic world, active modes will be even more important due
to reduced public transport capacities, as highlighted by the Department
for Transport’s £250m Active Travel Fund (ATF) and £2b allocated to
walking and cycling over the next 5 years in the UK alone.

New policies and investment programs such as the ATF have led to
increased demand for local evidence to inform interventions ranging from
new cycleways to improved pavement quality. This project will explore the
potential of open access transport sources such as OpenStreetMap (OSM)
and Ordnance Survey Open Roads (OSOR) datasets, and associated tools,
for transport planning to meet active travel objectives. Specifically,
the project will explore how open datasets can be used to understand,
prioritise and design active travel infrastructure, such as cycleways,
pavements, crossing points and traffic-calming features. The overall aim
is to research and add value to open transport infrastructure data — and
OpenStreetMap data in particular — for use in transport planning. The
outputs will include new insights, ideas and datasets, leading to a step
change in the accessibility, utility and understanding of crowd source
data for evidence-based decision making.

# Introduction

This repo contains code and example data to explore the utility of open
data for transport planning and, specifically, open data on transport
infrastructure. It was created to support a 12 month LIDA internship,
the objectives of which are to:

1.  develop new methods for bulk downloading, querying and analysing
    OpenStreetMap data on transport infrastructure
2.  assess the quality of OSM data with reference to ‘ground truth’
    datasets including data from satellite imagery and Ordnance Survey
    data
3.  develop a typology of transport infrastructure data and data schemas
    for each infrastructure type and an actionable definition of ‘active
    travel infrastructure’
4.  articulate ideas on how future research, datasets, software and
    tools could add value to open transport infrastructure data and
    support sustainable transport planning practice
5.  publish reproducible methods and documentation on using OSM data for
    transport planning with reference to the strengths and potential
    pitfalls of the data
6.  develop ‘OSM transport infrastructure data packs’ for every
    transport authority in Great Britain, with layers reflecting a
    typology of transport infrastructure data developed in the project
7.  develop and publish guidance on using OSM data for transport
    planning
8.  suggest a research agenda to enable better use of existing open
    datasets on transport infrastructure and envision future
    developments that could make transport planning more transparent,
    reproducible and participatory

The internship will be undertaken in two 6 month phases, with a rough
plan being for objectives 1:4 to be tackled during months 1:6 and
objectives 5:8 to be tackled during months 7:12. An agile approach will
be taken whereby objectives can be changed during the internship to
pursue promising avenues that emerge.

There are already good tools open tools for working with transport
infrastructure data, including the R packages
[`osmextract`](https://docs.ropensci.org/osmextract/),
[`stplanr`](https://docs.ropensci.org/stplanr/), and
[`sfnetworks`](https://luukvdmeer.github.io/sfnetworks/). These, and
packages written in other languages such as Julia and Python, are
largely academic-led and technical projects with little uptake among
practitioners. This project will explore the landscape of open transport
infrastructure, describe and critique how active travel infrastructure
is represented, and document how practitioners can better use open data
for evidence-based, transparent and participatory active travel
interventions.

Local authority planners and other stakeholders have more data than ever
before on transport systems to support their work, especially in
relation to travel *behaviour* thanks to datasets from traffic counts,
travel surveys and open access tools such as the Propensity to Cycle
Tool

However, there is less accessible data on travel *infrastructure*,
especially in relation to walking and cycling. Good practice on
designing for active travel is well known (Department for Transport
2007; Parkin 2018) and increasingly recommended/enforced. Recent
government publications provide clear guidance on design parameter for
active travel infrastructure, with the recent ‘[Cycle infrastructure
design](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/904088/cycle-infrastructure-design-ltn-1-20.pdf)’
guidance from the Department for Transport specifying ‘desirable’ and
‘absolute’ minimum widths of cycleways of 1.5m and 2m on cycleways with
low levels of cycle traffic, for example (Department for Transport
2020). However, little is known about the extent to which new
infrastructure is compliant with such guidance: there is no open data on
cycleway widths in most parts of the UK, leading to new approaches to
assess compliance using region-specific datasets (Tait et al. 2022).
Furthermore, new tools building on OSM datasets have been developed, for
example to model change in transport infrastructure, prioritise road
space reallocation schemes, and identify ‘low traffic neighbourhoods’
(e.g. Lovelace 2021; Lovelace et al. 2020; Lucas-Smith 2021). The
internship will generate new research and publications on additional
uses of open data to support sustainable transport planning objectives.

# Example of transport infrastructure in R

The brief example below shows how quickly you can get started with OSM
data using command-line driven open source software to ensure
reproducibility and scalability, based on an example put together for
[ODI
Manchester](https://github.com/Robinlovelace/openTransportDataDemo).

If you’re new to R, it may be worth reading up on introductory material
such as the free and open source resource *Reproducible Road Safety with
R* (Lovelace 2020) tutorial. See [Section
1.5](https://itsleeds.github.io/rrsrr/introduction.html#installing-r-and-rstudio)
of that tutorial to install R/RStudio and [Section
3](https://itsleeds.github.io/rrsrr/rstudio.html) on getting started
with the powerful RStudio editor. A strength of R is the number of high
quality and open access
[tutorials](https://education.rstudio.com/learn/beginner/),
[books](https://education.rstudio.com/learn/beginner/) and videos to get
started.

With R installed, you should be able to run all the code in this example
and reproduce the results.

The first step is to install some packages, by entering the following
commands into the R console:

``` r
pkgs = c(
  "pct",
  "stats19",
  "osmextract",
  "tmap",
  "stplanr",
  "od",
  "dplyr"
)
```

Install these packages as follows:

``` r
install.packages(pkgs)
```

Load the packages one-by-one with `library(pct)` etc, or all at once as
follows:

``` r
lapply(pkgs, library, character.only = TRUE)[length(pkgs)]
#> Data provided under OGL v3.0. Cite the source and link to:
#> www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
#> Data (c) OpenStreetMap contributors, ODbL 1.0. https://www.openstreetmap.org/copyright.
#> Check the package website, https://docs.ropensci.org/osmextract/, for more details.
#> Warning in fun(libname, pkgname): rgeos: versions of GEOS runtime 3.10.1-CAPI-1.16.0
#> and GEOS at installation 3.9.1-CAPI-1.14.2differ
#> 
#> Attaching package: 'od'
#> The following objects are masked from 'package:stplanr':
#> 
#>     od_id_character, od_id_max_min, od_id_order, od_id_szudzik,
#>     od_oneway, od_to_odmatrix, odmatrix_to_od
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> [[1]]
#>  [1] "dplyr"      "od"         "stplanr"    "osmextract" "stats19"   
#>  [6] "pct"        "tmap"       "sf"         "stats"      "graphics"  
#> [11] "grDevices"  "utils"      "datasets"   "methods"    "base"
```

One final line of code to set-up the environment is to switch `tmap`
into ‘view’ mode if you want to create interactive maps:

``` r
tmap_mode("view")
#> tmap mode set to interactive viewing
```

We will select the Worseley Building, home of LIDA, as the case study
area. As a starting point, we will use a 2 km buffer around the straight
line between LIDA and Leeds city centre to capture movement along this
transport corridor:

``` r
lida_point = tmaptools::geocode_OSM("Worsley Building, Leeds")
leeds_point = tmaptools::geocode_OSM("leeds")
c_m_coordiantes = rbind(lida_point$coords, leeds_point$coords)
c_m_od = od::points_to_od(p = c_m_coordiantes, interzone_only = TRUE)
c_m_desire_line = od::odc_to_sf(c_m_od[-(1:2)])[1, ]
lida_buffer = stplanr::geo_buffer(c_m_desire_line, dist = 2000)
```

``` r
qtm(lida_buffer)
```

``` r
sf::st_write(lida_buffer, "lida_buffer.geojson")
```
![](unnamed-chunk-8-1.png)

## Transport infrastructure data from osmextract

The following commands get transport infrastructure data. See
documentation on the [`osmextract`
website](https://docs.ropensci.org/osmextract/index.html) for details.

``` r
osm_data_full = osmextract::oe_get(lida_buffer, extra_tags = c("maxspeed", "lanes"))
osm_data_region = osm_data_full[lida_buffer, , op = sf::st_within]
summary(factor(osm_data_region$highway))
tmap_mode("plot")
tm_shape(osm_data_region) +
  tm_lines(col = "highway")
tmap_save(.Last.value, "osm_highway_map.png")
```

![](osm_highway_map.png)

The same approach can be used to get building polygons:

``` r
q = "select * from multipolygons where building in ('house', 'residential', 'office', 'commercial', 'detached', 'yes')"
osm_data_polygons = osmextract::oe_get(zones, query = q)
osm_data_polygons_region = osm_data_polygons[lida_buffer, , op = sf::st_within]
qtm(zones) +
  qtm(osm_data_polygons_region)
saveRDS(osm_data_polygons_region, "osm_data_polygons_region.Rds")
```

There is lots more we can do with this data and other open transport
datasets, and this project looks set to identify and document some of
the most important uses for sustainable transport planning.

<!-- ## Zone data from the PCT -->
<!-- The Propensity to Cycle Tool (PCT) is a research project and web application that provides data on transport patterns at high levels of geographic resolution across England and Wales. -->
<!-- The PCT is the main national tool that highway authorities use to support strategic cycle network plans and to ensure that investment goes in places, and transport corridors, with high cycling potential. -->
<!-- You can use the PCT in a web browser by navigating to www.pct.bike and clicking on a region of interest. -->
<!-- By making model results publicly the PCT enables more stakeholders to engage in the transport planning process than do proprietary tools only available to a handful of people with expensive licenses [@lovelace_open_2020]. -->
<!-- The PCT is also an open data project, and you can download data for any region in England and Wales in the Region data tab when using the tool. -->
<!-- You can also download data programmatically using the `pct` R package to enable others to build on the tool using the statistical programming language in which it was built. -->
<!-- This section demonstrates how to get and visualise key transport datasets from the PCT. -->
<!-- ```{r} -->
<!-- head(pct::pct_regions$region_name) -->
<!-- # zones = pct::get_pct_zones("west-yorkshire") # for smaller LSOA zones -->
<!-- zones = pct::get_pct_zones("west-yorkshire", geography = "msoa") -->
<!-- names(zones)[1:20] -->
<!-- names_to_plot = c("bicycle", "foot", "car_driver", "bus") -->
<!-- plot(zones[names_to_plot]) -->
<!-- ``` -->
<!-- To keep only zones whose centroids lie inside the study area we can use the following spatial subsetting code: -->
<!-- ```{r} -->
<!-- zone_centroids = sf::st_centroid(zones) -->
<!-- zone_centroids_lida = zone_centroids[lida_buffer, ] -->
<!-- zones = zones[zones$geo_code %in% zone_centroids_lida$geo_code, ] -->
<!-- saveRDS(zones, "zones.Rds") -->
<!-- ``` -->
<!-- Let's plot the result, to get a handle on the level of walking and cycling in the area (see interactive version of this map [here](https://rpubs.com/RobinLovelace/772770), shown are LSOA results): -->
<!-- ```{r, eval=FALSE} -->
<!-- tm_shape(zones) + -->
<!--   tm_fill(c("foot", "bicycle"), palette = "viridis") + -->
<!--   tm_shape(lida_buffer) + tm_borders(lwd = 3) -->
<!-- ``` -->
<!-- ![](https://i.imgur.com/oEuv1Zj.png) -->
<!-- ## Desire line data from the pct package -->
<!-- The maps shown in the previous section establish that there is a decent amount of cycling in the Chorlton area, at least according to the 2011 Census which is still a good proxy for travel patterns in 2021 due to the inertia of travel behaviours to change [@goodman_walking_2013]. -->
<!-- You can get national OD (origin/destination, also called desire line) data from the Census into R with the following command: -->
<!-- ```{r} -->
<!-- od_national = pct::get_od() -->
<!-- od_national -->
<!-- ``` -->
<!-- Let's keep only OD data that have a start and end point in the study area (in a transport simulation, we may also want trips starting or ending outside this area and passing through): -->
<!-- ```{r} -->
<!-- od = od_national %>%  -->
<!--   filter(geo_code1 %in% zones$geo_code) %>%  -->
<!--   filter(geo_code2 %in% zones$geo_code) -->
<!-- dim(od) -->
<!-- ``` -->
<!-- The result is nearly 300 rows of data representing movement between origin and destination zone centroids. -->
<!-- The data is non geographic, however. -->
<!-- To convert this non-geographic data into geographic desire lines, you can use the `od_to_sf()` function in the `od` package as follows: -->
<!-- ```{r} -->
<!-- desire_lines = od::od_to_sf(x = od, z = zones) -->
<!-- ``` -->
<!-- We'll calculated the straight line distance of these trips as follows: -->
<!-- ```{r} -->
<!-- desire_lines$length_km = as.numeric(sf::st_length(desire_lines)) / 1000 -->
<!-- summary(desire_lines$length_km) -->
<!-- ``` -->
<!-- We can plot the result as follows: -->
<!-- ```{r} -->
<!-- tmap_mode("plot") -->
<!-- qtm(zones) + -->
<!--   tm_shape(desire_lines) + -->
<!--   tm_lines(c("foot", "bicycle"), palette = "Blues", style = "jenks", lwd = 3, alpha = 0.5) -->
<!-- ``` -->
<!-- Note the OD data describes an aggregate pattern, between pairs of zones -- not between individual points-of-interest. -->
<!-- The following code returns only OD pairs with an origin in the Chorlton area: -->
<!-- ```{r} -->
<!-- od_lida = od %>%  -->
<!--   filter(geo_code1 %in% "E02001073") -->
<!-- ``` -->
<!-- ## Crash data from stats19 -->
<!-- A major deterrent to walking and cycling is motor traffic. -->
<!-- You can get open data on road traffic casulaties in the case study area over the last five years as follows: -->
<!-- ```{r, eval=FALSE} -->
<!-- library(stats19) -->
<!-- crashes = get_stats19(year = 2015:2019, output_format = "sf", lonlat = TRUE) -->
<!-- casualties = get_stats19(year = 2015:2019, type = "casualties") -->
<!-- crashes_combined = inner_join(crashes, casualties) -->
<!-- table(crashes_combined$casualty_type) -->
<!-- crashes_active = crashes_combined %>%  -->
<!--   filter(casualty_type %in% c("Pedestrian", "Cyclist")) -->
<!-- crashes_in_area = crashes_active[lida_buffer, ] -->
<!-- tm_shape(crashes_in_area) + -->
<!--   tm_dots("casualty_type", popup.vars = c("casualty_type", "accident_severity", "datetime"), palette = "viridis") -->
<!-- ``` -->
<!-- ![](https://i.imgur.com/oTYSwzQ.png) -->
<!-- ```{r, eval=FALSE, echo=FALSE} -->
<!-- sf::write_sf(crashes_in_area, "crashes_in_area.geojson") -->
<!-- piggyback::pb_upload("crashes_in_area.geojson") -->
<!-- piggyback::pb_download_url("crashes_in_area.geojson") -->
<!-- ``` -->
<!-- You can get the resulting crash data from: https://github.com/Robinlovelace/openTransportDataDemo/releases/download/1/crashes_in_area.geojson -->
<!-- ## Scenarios of change -->
<!-- You can model cycling uptake functions with the `pct` package as follows: -->
<!-- ```{r} -->
<!-- percent_cycling = pct::uptake_pct_godutch_2020(distance = desire_lines$length_km, gradient = 0) -->
<!-- plot(desire_lines$length_km, percent_cycling) -->
<!-- ``` -->
<!-- To get more realistic results, you would use route (not straight line) distance and hilliness from actual routes, not just desire lines. -->
<!-- Routing takes time but can be done with R packages such as `stplanr`. -->
<!-- For the purposes of illustration, we will use a simple uptake model implemented below: -->
<!-- ```{r} -->
<!-- desire_lines_go_active = desire_lines %>%  -->
<!--   mutate(car_driver = case_when(length_km < 2 ~ car_driver * 0.33, TRUE ~ car_driver)) %>%  -->
<!--   mutate(foot = case_when(length_km < 2 ~ foot + car_driver * (1 - 0.33), TRUE ~ foot)) %>%  -->
<!--   mutate(car_driver = car_driver * 0.5, bicycle = bicycle + car_driver * 0.5) %>%  -->
<!--   mutate_if(is.numeric, round) -->
<!-- sum(desire_lines_go_active$bicycle) -->
<!-- sum(desire_lines$bicycle) -->
<!-- sum(desire_lines_go_active$foot) -->
<!-- sum(desire_lines$foot) -->
<!-- ``` -->
<!-- ## Preparing data for A/B Street -->
<!-- ```{r, fig.show='hold', out.width="49%"} -->
<!-- remotes::install_github("a-b-street/abstr", ref = "ab_scenario2") -->
<!-- u = "https://github.com/Robinlovelace/openTransportDataDemo/releases/download/1/osm_data_polygons_region.Rds" -->
<!-- f = basename(u) -->
<!-- if(!file.exists(f)) { -->
<!--   download.file(url = u, destfile = f) -->
<!-- } -->
<!-- osm_data_polygons_region = readRDS("osm_data_polygons_region.Rds") -->
<!-- # Explore inputs and outputs of ab_scenario fun -->
<!-- desire_lines_abst = desire_lines %>%  -->
<!--   filter(geo_code1 == "E02001073") %>%  -->
<!--   transmute(o = geo_code1, d = geo_code2, all, Walk = foot, Bike = bicycle, Drive = car_driver, -->
<!--          Transit = light_rail + train + bus) -->
<!-- set.seed(2050) -->
<!-- desire_lines_disaggregated = abstr::ab_scenario(desire_lines_abst, zones = zones, -->
<!--                                                   subpoints = osm_data_polygons_region) -->
<!-- desire_lines_disaggregated %>%  -->
<!--  tm_shape() + -->
<!--   tm_lines("mode") + -->
<!--   qtm(osm_data_polygons_region) -->
<!-- desire_lines_json = abstr::ab_json(desire_lines_disaggregated["mode"], scenario_name = "baseline") -->
<!-- abstr::ab_save(x = desire_lines_json, "baseline.json") -->
<!-- # Go Active scenario -->
<!-- desire_lines_abst = desire_lines_go_active %>%  -->
<!--   filter(geo_code1 == "E02001073") %>%  -->
<!--   transmute(o = geo_code1, d = geo_code2, all, Walk = foot, Bike = bicycle, Drive = car_driver, -->
<!--          Transit = light_rail + train + bus) -->
<!-- set.seed(2050) -->
<!-- desire_lines_disaggregated = abstr::ab_scenario(desire_lines_abst, zones = zones, -->
<!--                                                   subpoints = osm_data_polygons_region) -->
<!-- desire_lines_disaggregated %>%  -->
<!--  tm_shape() + -->
<!--   tm_lines("mode") + -->
<!--   qtm(osm_data_polygons_region) -->
<!-- desire_lines_json = abstr::ab_json(desire_lines_disaggregated["mode"], scenario_name = "go_active") -->
<!-- abstr::ab_save(x = desire_lines_json, "go_active.json") -->
<!-- ``` -->
<!-- ```{r, eval=FALSE, echo=FALSE} -->
<!-- piggyback::pb_upload("go_active.json") -->
<!-- piggyback::pb_download_url("go_active.json") -->
<!-- fs::file_size("baseline.json") -->
<!-- # Explore inputs and outputs of ab_scenario fun -->
<!-- desire_lines_disaggregated = abstr::ab_scenario(desire_lines_abst, zones = zones) -->
<!-- piggyback::pb_upload("osm_data_polygons_region.Rds") -->
<!-- piggyback::pb_download_url("osm_data_polygons_region.Rds") -->
<!-- desire_lines_json = ab_json(desire_lines_disaggregated["mode"], scenario_name = "baseline") -->
<!-- ab_save(x = desire_lines_json, "baseline.json") -->
<!-- fs::file_size("baseline.json") -->
<!-- library(abstr) -->
<!-- ?ab_scenario -->
<!-- ab_evening_dutch = ab_scenario2( -->
<!--   leeds_houses, -->
<!--   leeds_buildings, -->
<!--   leeds_desire_lines, -->
<!--   leeds_zones, -->
<!--   scenario = "dutch", -->
<!--   output_format = "sf", -->
<!--   hr = 20, # representing 8 pm -->
<!--   sd = 0 -->
<!-- ) -->
<!-- head(leeds_desire_lines) -->
<!-- head(ab_evening_dutch) # output is simple: sf object with `mode` column. -->
<!-- nrow(ab_evening_dutch) -->
<!-- sum(leeds_desire_lines$all_base) -->
<!-- # issue to fix here:  -->
<!-- zones = zones %>%  -->
<!--   filter(geo_name %in% c(desire_lines$geo_code1, desire_lines$geo_code2)) -->
<!-- desire_lines_json = ab_json(desire_lines_disaggregated["mode"], scenario_name = "baseline") -->
<!-- ``` -->

# Further reading

-   To get started with R for transport research I recommend
    Reproducible Road Safety Research with R, an online version of which
    can be found here: <https://itsleeds.github.io/rrsrr/>
-   To get a deeper understanding of using geographic research transport
    research, Chapter 12 of the book Geocomputation with R is a great
    place to start: <https://geocompr.robinlovelace.net/transport.html>
-   For more on A/B Street scenarios, see here:
    <https://a-b-street.github.io/docs/dev/formats/scenarios.html>

For any questions, feel free to ask in a GitHub issue track assocated
with any of the repositories mentioned in this guide.

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-departmentfortransport_manual_2007" class="csl-entry">

Department for Transport. 2007. “Manual for Streets.” London: Telford.
<https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/341513/pdfmanforstreets.pdf>.

</div>

<div id="ref-departmentfortransport_cycle_2020" class="csl-entry">

———. 2020. “Cycle Infrastructure Design (LTN 1/20).” 1/20. Local
Transport Note. London.
<https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/904088/cycle-infrastructure-design-ltn-1-20.pdf>.

</div>

<div id="ref-ferster_using_2020" class="csl-entry">

Ferster, Colin, Jaimy Fischer, Kevin Manaugh, Trisalyn Nelson, and
Meghan Winters. 2020. “Using OpenStreetMap to Inventory Bicycle
Infrastructure: A Comparison with Open Data from Cities.” *International
Journal of Sustainable Transportation* 14 (1): 64–73.
<https://doi.org/10.1080/15568318.2018.1519746>.

</div>

<div id="ref-haklay_how_2010a" class="csl-entry">

Haklay, Mordechai. 2010. “How Good Is Volunteered Geographical
Information? A Comparative Study of OpenStreetMap and Ordnance Survey
Datasets.” *Environment and Planning B: Planning and Design* 37 (4):
682–703. <https://doi.org/10.1068/b35097>.

</div>

<div id="ref-lovelace_reproducible_2020" class="csl-entry">

Lovelace, Robin. 2020. “Reproducible Road Safety Research with R.” Royal
Automotive Club Foundation.
<https://www.racfoundation.org/wp-content/uploads/Reproducible_road_safety_research_with_R_Lovelace_December_2020.pdf>.

</div>

<div id="ref-lovelace_open_2021" class="csl-entry">

———. 2021. “Open Source Tools for Geographic Analysis in Transport
Planning.” *Journal of Geographical Systems*, January.
<https://doi.org/10.1007/s10109-020-00342-2>.

</div>

<div id="ref-lovelace_methods_2020" class="csl-entry">

Lovelace, Robin, Joseph Talbot, Malcolm Morgan, and Martin Lucas-Smith.
2020. “Methods to Prioritise Pop-up Active Transport Infrastructure.”
*Transport Findings*, July, 13421.
<https://doi.org/10.32866/001c.13421>.

</div>

<div id="ref-lucas-smith_mapping_2021" class="csl-entry">

Lucas-Smith, Martin. 2021. “Mapping Modal Filters and LTNs.”
CycleStreets. July 25, 2021.
<https://www.cyclestreets.org/news/2021/07/25/mapping-ltns/>.

</div>

<div id="ref-orozco_datadriven_2020" class="csl-entry">

Orozco, Luis, Federico Battiston, Gerardo Iñiguez, and Michael Szell.
2020. “Data-Driven Strategies for Optimal Bicycle Network Growth.”
*Royal Society Open Science* 7 (December): 201130.
<https://doi.org/10.1098/rsos.201130>.

</div>

<div id="ref-parkin_designing_2018" class="csl-entry">

Parkin, John. 2018. *Designing for Cycle Traffic: International
Principles and Practice*. ICE Publishing.
<https://www.icevirtuallibrary.com/isbn/9780727763495>.

</div>

<div id="ref-tait_cycling_2022" class="csl-entry">

Tait, Caroline, Roger Beecham, Robin Lovelace, and Stuart Barber. 2022.
“Is Cycling Infrastructure in London Safe and Equitable? Evidence from
the Cycling Infrastructure Database.”

</div>

</div>
