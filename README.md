
# YAC19

<!-- badges: start -->
<!-- badges: end -->

YAC19 fetches and presents statistical data about the number of COVID-19 infections in Germany.

## Usage

##### Download of dataset

This package provides two different download functions. With 
``` r
rki_fetch_all()
```
you will get the most recent complete dataset.

**Please note**: Due to the size of the data this may take several minutes. 

If you are only interested in a specific time span you can use 
``` r
rki_fetch(from_date, to_date, out_fields = "*")
```
`out_fields` describes what columns are included in the dataframe. By default these
are all columns. 

**Please note**: Due to the API's limitation a maximum of 32000 rows is returned
at one time. This essentially limits the usage of this function to only download
the data for a span of 1-2 days.

##### Plot function
`plot_rate_death()` can be used to visualize the rate of death over time for 
each gender.

Example:
``` r
plot_rate_death(covrki, "A80+", 100, 30) 
```
To limit the plot to a certain time span use `filter_date()`.

##### Numerical summary
`table_rate_of_deaths_by_state` can be used summarize the rate of death by 
gender and state.

Example: 
``` r
table_rate_of_deaths_by_state(covrki)
```

##### Example Dataset
The package includes the example dataset `covrki`. It includes all publicly 
available data about COVID-19 cases in Germany provided by the RKI. It spans 
all cases from January 1st, 2020 up to February 10th, 2021 that were recorded 
by February 12th, 2021.

You can get an updated version of this dataset with `rki_fetch_all()`.

---

For more information see the respective function/data documentation.

---
