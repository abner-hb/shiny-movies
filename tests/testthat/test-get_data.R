test_that("get_rows works", {
    # Testing check that vectors have the same length
    expect_error(
        get_rows(c("actors", "director"), c("jormungandr")),
        regexp = "Each column must have one condition"
    )
    expect_error(
        get_rows(c("actors"), c("jormungandr", "lol")),
        regexp = "Each column must have one condition"
    )
    expect_error(
        get_rows(NULL, c("jormungandr", "lol")),
        regexp = "Each column must have one condition"
    )
    # Testing that the check for no results works
    expect_error(
        get_rows(c("director"), c("jormungandr")),
        regexp = "We found no movies with the desired conditions"
    )
    # expect_equal(
    #     get_rows(c("director"), c("jormungandr")),
    #     regexp = "We found no movies with the desired conditions"
    # )
    # 
})
test = "director"
