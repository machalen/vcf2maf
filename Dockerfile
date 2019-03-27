########################################################################
#Dockerfile to build vcf2maf latest version from:
#https://github.com/mskcc/vcf2maf
#Also the programs: vcftools, samtools, bcftools, liftover and vcf2maf
########################################################################
#Build the image from the variant effect predictor package
FROM opengenomics/variant-effect-predictor-tool

#Mantainer
MAINTAINER Magdalena Arnal <marnal@imim.es>

ENV PATH $VEP_PATH/htslib:$PATH
ENV PERL5LIB $VEP_PATH:/opt/lib/perl5:$PERL5LIB

#Install required packages
WORKDIR /bin
RUN apt-get update -y && \
    apt-get install --yes \
    libncurses5-dev vcftools wget unzip bzip2 g++ make libbz2-dev liblzma-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
#Install samtools
WORKDIR /bin
RUN wget http://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN tar --bzip2 -xf samtools-1.9.tar.bz2
WORKDIR /bin/samtools-1.9
RUN ./configure
RUN make
RUN rm /bin/samtools-1.9.tar.bz2
ENV PATH $PATH:/bin/samtools-1.9

#Install bcftools
WORKDIR /bin
RUN curl -L -o tmp2.tar.gz https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 && \
    mkdir bcftools && \
    tar -C bcftools --strip-components 1 -jxf tmp2.tar.gz && \
    cd bcftools && \
    make && \
    make install && \
    cd .. && \
    rm /bin/tmp2.tar.gz
ENV PATH $PATH:/bin/bcftools

#install liftover
RUN curl -L http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/liftOver > /usr/local/bin/liftOver && \
    chmod a+x /usr/local/bin/liftOver
    
#Install vcftomaf
WORKDIR /bin
RUN curl -ksSL -o tmp.tar.gz https://github.com/mskcc/vcf2maf/archive/v1.6.16.tar.gz && \
    mkdir vcf2maf && \
    tar -C vcf2maf --strip-components 1 -zxf tmp2.tar.gz && \
    cd vcf2maf && \
    chmod +x *.pl \
    rm /bin/tmp2.tar.gz
ENV PATH $PATH:/bin/vcf2maf
