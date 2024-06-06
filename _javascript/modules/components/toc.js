export function toc() {
  // see: https://github.com/tscanlin/tocbot#usage
  if (document.querySelector("main h2,main h3,main h4,main h5")) {
    tocbot.init({
      tocSelector: '#toc',
      contentSelector: '.content',
      ignoreSelector: '[data-toc-skip]',
      headingSelector: 'h2, h3, h4',
      orderedList: false,
      scrollSmooth: false
    });
  }
}
