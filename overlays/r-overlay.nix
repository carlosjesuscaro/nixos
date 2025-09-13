# /etc/nixos/overlays/r-overlay.nix
self: super: {
  myR = super.rWrapper.override {
    packages = with super.rPackages; [
      tidyverse
      data_table
      janitor
      lubridate
      stringr
      forcats

      ggplot2
      plotly
      patchwork

      rmarkdown
      knitr
      bookdown
      kableExtra

      shiny
      shinydashboard
      shinyWidgets
      htmlwidgets
      DT

      devtools
      remotes
      usethis
      testthat
      roxygen2
      languageserver
      styler
      lintr

      readxl
      writexl
      openxlsx
      jsonlite
      httr
      curl

      future
      furrr
      arrow
    ];
  };
}

