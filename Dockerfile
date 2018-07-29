FROM r-base:latest

MAINTAINER Winston Chang "winston@rstudio.com"
# modified by Markus Bockhacker "hello@s1lvester.de" for study-project # "shinyLabView"

RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    libssl-dev \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev && \
    wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', \
                             'rmarkdown', \
                             'flexdashboard', \
                             'dplyr', \
                             'lubridate', \
                             'DT', \
                             'scales', \
                             'ggplot2', \
                             'plotly'), \
                             repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

COPY shiny-customized.config /etc/shiny-server/shiny-server.conf

RUN wget https://raw.githubusercontent.com/s1lvester/shinyLabView/master/shinyLabView/flexdashboard.Rmd -O /srv/shiny-server/index.Rmd
RUN wget https://raw.githubusercontent.com/s1lvester/shinyLabView/master/shinyLabView/labData.csv -O /srv/shiny-server/labData.csv
RUN wget https://raw.githubusercontent.com/s1lvester/shinyLabView/master/shinyLabView/labData.csv -O /srv/shiny-server/labData-Tests.csv
RUN wget https://raw.githubusercontent.com/s1lvester/shinyLabView/master/shinyLabView/labData.csv -O /srv/shiny-server/labData-Tests-norm.csv
RUN wget https://raw.githubusercontent.com/s1lvester/shinyLabView/master/shinyLabView/patientData.csv -O /srv/shiny-server/patientData.csv
RUN wget https://raw.githubusercontent.com/s1lvester/shinyLabView/master/shinyLabView/normValues.csv -O /srv/shiny-server/normValues.csv

CMD ["/usr/bin/shiny-server.sh"]

