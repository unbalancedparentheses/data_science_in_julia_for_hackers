// Same-origin static demos grow with their content, including on narrow screens.
for (const frame of document.querySelectorAll('iframe[data-interactive]')) {
  let observer;
  function connect() {
    observer?.disconnect();
    const body=frame.contentDocument?.body;
    if (!body) return;
    const resize=()=>{
      const style=frame.contentWindow.getComputedStyle(body);
      const height=Math.ceil(body.getBoundingClientRect().height +
        parseFloat(style.marginTop || 0) + parseFloat(style.marginBottom || 0));
      frame.style.height=`${Math.max(450,height+8)}px`;
    };
    observer=new ResizeObserver(resize);
    observer.observe(body);
    resize();
  }
  frame.addEventListener('load',connect);
  if (frame.contentDocument?.readyState==='complete') connect();
}
