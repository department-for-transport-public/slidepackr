#' An R Markdown output format for remark.js slides
#'
#' This output format produces an HTML file that contains the Markdown source
#' (knitted from R Markdown) and JavaScript code to render slides.
#'
#' @param css A vector of CSS file paths. Three default CSS files
#'   (\file{default.css}, \file{default-fonts.css} and \file{dft.css}) are provided in this
#'   package.
#'   
#'   To add custom css files to your slidepack, you can add a reference to the 
#'   css file in this character vector e.g., for \code{css = c('default', 'extra.css')}).
#' @param nature (Nature transformation) A list of configurations to be passed
#'   to \code{remark.create()}, e.g. \code{list(ratio = '16:9', navigation =
#'   list(click = TRUE))}; see
#'   \url{https://github.com/gnab/remark/wiki/Configuration}. Besides the
#'   options provided by remark.js, you can also set \code{autoplay} to a number
#'   (the number of milliseconds) so the slides will be played every
#'   \code{autoplay} milliseconds; alternatively, \code{autoplay} can be a list
#'   of the form \code{list(interval = N, loop = TRUE)}, so the slides will go
#'   to the next page every \code{N} milliseconds, and optionally go back to the
#'   first page to restart the play when \code{loop = TRUE}. You can also set
#'   \code{countdown} to a number (the number of milliseconds) to include a
#'   countdown timer on each slide. If using \code{autoplay}, you can optionally
#'   set \code{countdown} to \code{TRUE} to include a countdown equal to
#'   \code{autoplay}. To alter the set of classes applied to the title slide,
#'   you can optionally set \code{titleSlideClass} to a vector of classes; the
#'   default is \code{c("center", "middle", "inverse")}.
#' @param ... arguments passed to rmarkdown HTML format.

#' @importFrom htmltools tagList tags htmlEscape HTML 
#' @importFrom knitr hooks_markdown 
#' @importFrom rmarkdown knitr_options
#' @export
#' @name dft_slidepack
#' @examples
#' # rmarkdown::render('foo.Rmd', 'slidepackR::dft_slidepack')
dft_slidepack = function(
  css = c('default', 'dft'), 
  nature = list(),
  ...
) {
  theme = grep('[.](?:sa|sc|c)ss$', css, value = TRUE, invert = TRUE)
  deps = if (length(theme)) {
    css = setdiff(css, theme)
    check_builtin_css(theme)
    list(css_deps(theme))
  }
  tmp_js = tempfile('slidepackr', fileext = '.js')  # write JS config to this file
  tmp_md = tempfile('slidepackr', fileext = '.md')  # store md content here (bypass Pandoc)

  options(slidepackr.page_number.offset = -1L)
  
  if (is.numeric(autoplay <- nature[['autoplay']])) {
    autoplay = list(interval = autoplay, loop = FALSE)
  }
  play_js = if (is.numeric(intv <- autoplay$interval) && intv > 0) sprintf(
    'setInterval(function() {slideshow.gotoNextSlide();%s}, %d);',
    if (!isTRUE(autoplay$loop)) '' else
      ' if (slideshow.getCurrentSlideIndex() == slideshow.getSlideCount() - 1) slideshow.gotoFirstSlide();',
    intv
  )
  
  if (isTRUE(countdown <- nature[['countdown']])) countdown = autoplay
  countdown_js = if (is.numeric(countdown) && countdown > 0) sprintf(
    '(%s)(%d);', pkg_file('js/countdown.js'), countdown
  )
  
  hl_pre_js = if (isTRUE(nature$highlightLines))
    pkg_file('js/highlight-pre-parent.js')
  
  if (is.null(title_cls <- nature[['titleSlideClass']]))
    title_cls = c('center', 'middle', 'inverse')
  title_cls = paste(c(title_cls, 'title-slide'), collapse = ', ')
  
  before = nature[['beforeInit']]
  for (i in c('countdown', 'autoplay', 'beforeInit', 'titleSlideClass')) nature[[i]] = NULL
  
  write_utf8(as.character(tagList(
    tags$style(`data-target` = 'print-only', '@media screen {.remark-slide-container{display:block;}.remark-slide-scaler{box-shadow:none;}}'),
    tags$script(src = "libs/remark-latest.min.js"),
    if (is.character(before))  {
      tags$script(HTML(file_content(before)))
    } else {
      lapply(before, function(s) tags$script(src = s))
    },
    tags$script(HTML(paste(c(sprintf(
      'var slideshow = remark.create(%s);', if (length(nature)) xfun::tojson(nature) else ''
    ), pkg_file(sprintf('js/%s.js', c(
      'show-widgets', 'print-css', 'after', 'script-tags', 'target-blank'
    ))),
    play_js, countdown_js, hl_pre_js), collapse = '\n')))
  )), tmp_js)
  
  html_document2 = function(
    ..., includes = list(), mathjax = 'default', pandoc_args = NULL
  ) {
    if (length(includes) == 0) includes = list()
    includes$before_body = c(includes$before_body, tmp_md)
    includes$after_body = c(tmp_js, includes$after_body)
    if (identical(mathjax, 'local'))
      stop("mathjax = 'local' does not work for moon_reader()")
    if (!is.null(mathjax)) {
      if (identical(mathjax, 'default')) {
        mathjax = 'https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-MML-AM_CHTML'
      }
      pandoc_args = c(pandoc_args, '-V', paste0('mathjax-url=', mathjax))
      mathjax = NULL
    }
    pandoc_args = c(pandoc_args, '-V', paste0('title-slide-class=', title_cls))
    rmarkdown::html_document(
      ..., includes = includes, mathjax = mathjax, pandoc_args = pandoc_args
    )
  }
  
  highlight_hooks = NULL
  if (isTRUE(nature$highlightLines)) {
    hooks = knitr::hooks_markdown()[c('source', 'output')]
    highlight_hooks = list(
      source = function(x, options) {
        hook = hooks[['source']]
        res = hook(x, options)
        highlight_code(res)
      },
      output = function(x, options) {
        hook = hooks[['output']]
        res = highlight_output(x, options)
        hook(res, options)
      }
    )
  }
  
  # don't use Pandoc raw blocks ```{=} (#293)
  opts = options(htmltools.preserve.raw = FALSE)
  
  rmarkdown::output_format(
    rmarkdown::knitr_options(knit_hooks = highlight_hooks),
    NULL, clean_supporting = TRUE,
    pre_processor = function(
      metadata, input_file, runtime, knit_meta, files_dir, output_dir
    ) {
      res = split_yaml_body(input_file)
      write_utf8(res$yaml, input_file)
      res$body = protect_math(res$body)
      
        clean_env_images()
        res$body = encode_images(res$body)
        cat(sprintf(
          "<script>(%s)(%s, '%s');</script>", pkg_file('js/data-uri.js'),
          xfun::tojson(as.list(env_images, all.names = TRUE)), url_token
        ), file = tmp_js, append = TRUE)
      
      content = htmlEscape(res$body)
      Encoding(content) = 'UTF-8'
      write_utf8(content, tmp_md)
      c(
        if (!identical(body, res$body)) c('--variable', 'math=true')
      )
    },
    on_exit = function() {
      unlink(c(tmp_md, tmp_js))
      options(opts)
    },
    base_format = html_document2(
      css = css, self_contained = TRUE, theme = NULL, highlight = NULL,
      extra_dependencies = deps, template = pkg_resource('default.html'),
      anchor_sections = FALSE, ...
    )
  )
}

