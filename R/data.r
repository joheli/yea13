#' Surveillance dataset of Staphylococcus aureus
#'
#' A surveillance dataset of susceotibility tests from three hospitals.
#' Columns 'id', 'time' and 'unit' have been altered to prevent identification of cases.
#' Susceptibility categorization (1 = susceptible, 2 = intermediate, 3 = resistant) has been performed according to EUCAST 9.0, with the exception of Rifampicin.
#'
#' @format A data frame with 474 rows and 25 variables:
#' \describe{
#'   \item{id}{strain identifier (generated during data export, not identical to original strain id)}
#'   \item{time}{time of request (altered by addition of a constant value)}
#'   \item{unit}{ward name (remapped to fake names)}
#'   \item{Ampicillin}{susceptibility category of antibiotic 'Ampicillin'}
#'   \item{Ampicillin+Sulbactam}{susceptibility category of antibiotic 'Ampicillin+Sulbactam'}
#'   \item{Cefpodoxim}{susceptibility category of antibiotic 'Cefpodoxim'}
#'   \item{Cefuroxim}{susceptibility category of antibiotic 'Cefuroxim'}
#'   \item{Ciprofloxacin}{susceptibility category of antibiotic 'Ciprofloxacin'}
#'   \item{Clindamycin}{susceptibility category of antibiotic 'Clindamycin'}
#'   \item{Co-trimoxazol}{susceptibility category of antibiotic 'Co-trimoxazol'}
#'   \item{Daptomycin}{susceptibility category of antibiotic 'Daptomycin'}
#'   \item{Erythromycin}{susceptibility category of antibiotic 'Erythromycin'}
#'   \item{Fosfomycin}{susceptibility category of antibiotic 'Fosfomycin'}
#'   \item{Gentamicin}{susceptibility category of antibiotic 'Gentamicin'}
#'   \item{Imipenem}{susceptibility category of antibiotic 'Imipenem'}
#'   \item{Linezolid}{susceptibility category of antibiotic 'Linezolid'}
#'   \item{Moxifloxacin}{susceptibility category of antibiotic 'Moxifloxacin'}
#'   \item{Oxacillin}{susceptibility category of antibiotic 'Oxacillin'}
#'   \item{Penicillin G}{susceptibility category of antibiotic 'Penicillin G' (Benzylpenicillin)}
#'   \item{Piperacillin+Tazobactam}{susceptibility category of antibiotic 'Piperacillin+Tazobactam'}
#'   \item{Rifampicin}{susceptibility category of antibiotic 'Rifampicin'}
#'   \item{Teicoplanin}{susceptibility category of antibiotic 'Teicoplanin'}
#'   \item{Tetrazyklin}{susceptibility category of antibiotic 'Tetrazyklin' (tetracyline)}
#'   \item{Tigecyclin}{susceptibility category of antibiotic 'Tigecyclin' (tigecycline)}
#'   \item{Vancomycin}{susceptibility category of antibiotic 'Vancomycin'}
#' }
"s_aureus"

#' Surveillance dataset of Enterobacter cloacae
#'
#' A surveillance dataset of susceotibility tests from three hospitals.
#' Columns 'id', 'time' and 'unit' have been altered to prevent identification of cases.
#' Susceptibility categorization (1 = susceptible, 2 = intermediate, 3 = resistant) has been performed according to EUCAST 9.0.
#'
#' @format A data frame with 121 rows and 21 variables:
#' \describe{
#'   \item{id}{strain identifier (generated during data export, not identical to original strain id)}
#'   \item{time}{time of request (altered by addition of a constant value)}
#'   \item{unit}{ward name (remapped to fake names)}
#'   \item{Amikazin}{susceptibility category of antibiotic 'Amikazin'}
#'   \item{Ampicillin}{susceptibility category of antibiotic 'Ampicillin'}
#'   \item{Ampicillin+Sulbactam}{susceptibility category of antibiotic 'Ampicillin+Sulbactam'}
#'   \item{Cefepim}{susceptibility category of antibiotic 'Cefepim'}
#'   \item{Cefotaxim}{susceptibility category of antibiotic 'Cefotaxim'}
#'   \item{Cefpodoxim}{susceptibility category of antibiotic 'Cefpodoxim'}
#'   \item{Ceftazidime}{susceptibility category of antibiotic 'Ceftazidime'}
#'   \item{Cefuroxim}{susceptibility category of antibiotic 'Cefuroxim'}
#'   \item{Ciprofloxacin}{susceptibility category of antibiotic 'Ciprofloxacin'}
#'   \item{Co-trimoxazol}{susceptibility category of antibiotic 'Co-trimoxazol'}
#'   \item{Ertapenem}{susceptibility category of antibiotic 'Ertapenem'}
#'   \item{Fosfomycin}{susceptibility category of antibiotic 'Fosfomycin'}
#'   \item{Gentamicin}{susceptibility category of antibiotic 'Gentamicin'}
#'   \item{Imipenem}{susceptibility category of antibiotic 'Imipenem'}
#'   \item{Meropenem}{susceptibility category of antibiotic 'Meropenem'}
#'   \item{Piperacillin}{susceptibility category of antibiotic 'Piperacillin'}
#'   \item{Piperacillin+Tazobactam}{susceptibility category of antibiotic 'Piperacillin+Tazobactam'}
#'   \item{Tobramycin}{susceptibility category of antibiotic 'Tobramycin'}
#' }
"e_cloacae"

#' Surveillance dataset of Klebsiella pneumoniae
#'
#' A surveillance dataset of susceotibility tests from three hospitals.
#' Columns 'id', 'time' and 'unit' have been altered to prevent identification of cases.
#' Susceptibility categorization (1 = susceptible, 2 = intermediate, 3 = resistant) has been performed according to EUCAST 9.0.
#'
#' @format A data frame with 245 rows and 21 variables:
#' \describe{
#'   \item{id}{strain identifier (generated during data export, not identical to original strain id)}
#'   \item{time}{time of request (altered by addition of a constant value)}
#'   \item{unit}{ward name (remapped to fake names)}
#'   \item{Amikazin}{susceptibility category of antibiotic 'Amikazin'}
#'   \item{Ampicillin}{susceptibility category of antibiotic 'Ampicillin'}
#'   \item{Ampicillin+Sulbactam}{susceptibility category of antibiotic 'Ampicillin+Sulbactam'}
#'   \item{Cefepim}{susceptibility category of antibiotic 'Cefepim'}
#'   \item{Cefotaxim}{susceptibility category of antibiotic 'Cefotaxim'}
#'   \item{Cefpodoxim}{susceptibility category of antibiotic 'Cefpodoxim'}
#'   \item{Ceftazidime}{susceptibility category of antibiotic 'Ceftazidime'}
#'   \item{Cefuroxim}{susceptibility category of antibiotic 'Cefuroxim'}
#'   \item{Ciprofloxacin}{susceptibility category of antibiotic 'Ciprofloxacin'}
#'   \item{Co-trimoxazol}{susceptibility category of antibiotic 'Co-trimoxazol'}
#'   \item{Ertapenem}{susceptibility category of antibiotic 'Ertapenem'}
#'   \item{Fosfomycin}{susceptibility category of antibiotic 'Fosfomycin'}
#'   \item{Gentamicin}{susceptibility category of antibiotic 'Gentamicin'}
#'   \item{Imipenem}{susceptibility category of antibiotic 'Imipenem'}
#'   \item{Meropenem}{susceptibility category of antibiotic 'Meropenem'}
#'   \item{Piperacillin}{susceptibility category of antibiotic 'Piperacillin'}
#'   \item{Piperacillin+Tazobactam}{susceptibility category of antibiotic 'Piperacillin+Tazobactam'}
#'   \item{Tobramycin}{susceptibility category of antibiotic 'Tobramycin'}
#' }
"k_pneumoniae"

#' Network graph of 78 units of a hospital trust consisting of three hospitals
#'
#' An \code{\link{igraph}} object with 78 nodes representing units (mostly wards) generated from laboratory request data (full blood count) over a month.
#' Movements across nodes are assumed to represent patient movements.
#'
#' @format An \code{\link{igraph}} object
"units_igraph"

#' Matrix of effective distances between wards.
#'
#' A quadratic matrix containing effective distances between wards. Effective distances have been
#' calculated from \code{\link{igraph}} object \code{\link{units_igraph}} using function \code{\link{graph2effdist}}, which depends on package \code{\link{NetOrigin}}.
#' Ward names (column and row ids) have been remapped to fake names to prevent their identification.
#'
#' @format A quadratic matrix with 78 rows and 78 columns.
"units_effdist"
