
<!-- README.md is generated from README.Rmd. Please ed  it that file -->

# BioNetworks

<!-- badges: start -->
<!-- badges: end -->

The goal of BioNetworks is to analyze biological networks using graph
theory concepts. ![](man/figures/README-Network.png)

## Installation

Install the Beta version of BioNetworks:

``` r
library(devtools)
devtools::install_github("yzohdy/BioNetworks")
```

## Workflow

This is a basic example which shows you how to analyze a set of
differential expressed genes (DEGs) or proteins. The following example
outlines the use of this package to identify a set of DEGs in a
microarray dataset. However, this package would work just as well with RNA-seq
or proteomics data.

``` r
library(BioNetworks)
```

## 1 - Identification of Differentially Expressed Genes/Proteins

The following function is used to extract a list of DEGs from
a normalized microarray dataset. If using RNA-Seq data, simply use
the counts table from DESeq2 or a similiar package for DEG identification.

``` r
#Identification of DEGs from a normalized Nanostring dataset (nano.counts)
DEG <- microarray_degs(data = nano.counts, control = "CTL", condition = "RX")

#Functional annotation of the identifed DEGs
DEG.fun <- degs_f_annotation(DEG, species = "Hs")
```

## 2 - Genes Co-Expression

Before constructing the interaction network, use either of the following
functions to compute a co-expression score for genes present within your
dataset.

### 2.1 - Pearson Correlation

The gene_coexpression_r() function simply uses pearson correlation to
score the strength of co-expression between different genes.

``` r
p.coexpr.df <- genes_coexpression_r(nano.counts)
```

### 2.2 - Scaled Co-Expression

Another available method for calculating the co-expression values is
using the WGCNA package correlation powered analysis. The function
genes_coexpression() offers an easy way of using this method.

``` r
s.coexpr.df <- genes_coexpression_s(nano.counts)
```

## 3 - Interaction Network Construction

Next we construction an interaction network from the pre-identified
DEGs.

### 3.1 - Identification of Node Interactions.

First we create an interaction dataframe using pre-identified
interaction from STRING database.

``` r
#Identifying interactions
int.df <- ident_interactions(DEG, species = "Hs")

#Merging interactions with computed co-expression scores
full_int.df <- merge_int_expr(int.df, s.coexpr.df, int_cols = c("from", "to"), coexpr_cols = c("Var1", "Var2"))
```

### 3.2 - Construction and Visualization of Network

The network is then constructed with each node corresponding to a gene
and each edge represents nodal interaction weighted by co-expression
values.

``` r
#Network construction
study.net <- construct_network(full_int.df, interaction_score = "Freq")

#Visualize network with Cytoscape - make sure Cytoscape app is open before running this function
visualize_net(study.net)
```

## 4 - Graph Theory Analysis

### 4.1 - Checking the Presence of a Scale-Free Network Topology

Almost all biological networks exhibit a scale-free topology with
centeral highly connected nodes and a decrease in connectivity at the
network periphery, show by a power-law distribution of node degrees.

``` r
plot_degrees_dist(study.net)
```

### 4.2 - Construction of Random Networks

A cornerstone of comparing the topology of a network is comparison to sets of randomly constructed networks. The construct_rand_net()
constructs a list of random networks with of similar weighted degree
distribution based on Fabien Viger and Matthieu Latapy’s algorithm.

``` r
rand.nets <- construct_rand_net(study.net, number = 100)
```

### 4.3 - Clustering Coefficient

We then compare the clustering coefficient of the study network with the
randomly constructed networks to ensure the presence of a scale-free
network.

``` r
#Calculate the clustering coefficient for the study networks
net.clu.coeff <- net_clu_coeff(study.net)

#Calculate the clustering coefficient for the random networks
rand.clu.coeff <- rand_net_clu_coeff(rand.nets)

#One sample t-test between random networks clustering coefficient and the study network
clu.coeff.t.test <- t.test(rand.clu.coeff, mu= net.clu.coeff)
```

### 4.4 - Rich-Club Analysis

The ‘rich-club’ phenomenon refers to the tendency of nodes with high
centrality, the dominant elements of a network, to form tightly
interconnected subnetworks, and it is one of the crucial properties
accounting for the formation of scale-free biological network. The
following functions demonstrate the identification of network core nodes
using the rich-club analysis. The compare_rc_coeff() function calculates
the rich-club coefficient for both the study network and the list of
random networks and calculates a normalized coefficient. The normalized
coefficient is then used to set a cut-off to identify the ndoes with the
highest degrees of connectivity.

``` r
#Calculating rich-club coefficient
rc.coeff.df <- compare_rc_coeff(study.net, rand.nets)

#Identify core nodes
core.nodes <- rc_nodes(study.net, rc.coeff.df)

#Visualizing the identify core nodes
visualize_net(core.nodes)

#Comparing the nodal degrees between the core nodes and other network nodes
compare_rc_degrees(study.net, core.nodes)

#Functional annotation of the core nodes - fix!!
core.fun <- degs_f_annotation(core.nodes, species = "Hs") 
```

## 5 - Correlation between Core Nodes and Traits

We then investigate the correlation between the identified core nodes
and traits. Correlation are made based on the PCA compute eigengenes for
the core nodes. Those correlation are then compared with multiple
iterations of random sampling of non-core nodes.

``` r
#Calculate core nodes eigengenes
core.nodes.eg <- core_eigengenes(nano.counts,study.net,core.nodes)

#Calculate the non-core nodes eigengenes
noncore.nodes.eg <- non_core_eigengenes(nano.counts, study_network, core.nodes, number =100)

#Correlate with a specific trait
core.correlation <- core_nodes_correlation(core.nodes.eg, noncore.nodes.eg, outcomes.df, tested_outcome="survival")
```
