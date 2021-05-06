## Bookdown installation 

To use Bookdown you first need to install:
* [R](https://www.r-project.org/) programming language. 
* The development environment [RStudio](https://www.rstudio.com/).
* Add the R packages [Bookdown](https://github.com/rstudio/bookdown) and [JuliaCall]( https://github.com/Non-Contradiction/JuliaCall).
    
    NOTE: For the time being, JuliaCall is having an [issue](https://github.com/Non-Contradiction/JuliaCall/issues/164) with the Julia 1.6 version. So you will need to set Julia version v1.5.4 or older as the default one.

## Workflow

1. Make all the modifications to the chapter you are working on in the .Rmd file.

2. Once you finish making all the modifications, run all the code cells to make sure you don't get any error.

3. Since Data science in Julia for hackers has chapters that involve a lot of computation we render each chapter separately.

    To render a chapter, we run the following method in the RStudio console:

    `bookdown::preview_chapter(“{Rmd_file}”)`
    
    Once the .html file is created you will see the console output:

    `Output created: docs/{title}.html`

4. If you open the .html file, you will notice that in the left-side index the sections dividers are missing. So you will need to add them manually: 

    Open the .html file, copy the summary code from another chapter and replace it in the one you just created: 

    ```
    <ul class="summary">
    ...
    </ul>
    ```

    Now you can open the .html file and see that the section dividers are now displayed in the left-side index of the book.



