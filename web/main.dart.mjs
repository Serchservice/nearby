// Returns whether the `js-string` built-in is supported.
function detectJsStringBuiltins() {
  let bytes = [
    0,   97,  115, 109, 1,   0,   0,  0,   1,   4,   1,   96,  0,
    0,   2,   23,  1,   14,  119, 97, 115, 109, 58,  106, 115, 45,
    115, 116, 114, 105, 110, 103, 4,  99,  97,  115, 116, 0,   0
  ];
  return WebAssembly.validate(
    new Uint8Array(bytes), {builtins: ['js-string']});
}

// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = detectJsStringBuiltins()
      ? {builtins: ['js-string']} : {};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = detectJsStringBuiltins()
      ? {builtins: ['js-string']} : {};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  async instantiate(additionalImports, {loadDeferredWasm} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
      const exports = dartInstance.exports;
      const read = exports.$listRead;
      const length = exports.$listLength(list);
      const array = new constructor(length);
      for (let i = 0; i < length; i++) {
        array[i] = read(list, i);
      }
      return array;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {

      _1: (x0,x1,x2) => x0.set(x1,x2),
      _2: (x0,x1,x2) => x0.set(x1,x2),
      _6: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._6(f,arguments.length,x0) }),
      _7: x0 => new window.FinalizationRegistry(x0),
      _8: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _9: (x0,x1) => x0.unregister(x1),
      _10: (x0,x1,x2) => x0.slice(x1,x2),
      _11: (x0,x1) => x0.decode(x1),
      _12: (x0,x1) => x0.segment(x1),
      _13: () => new TextDecoder(),
      _14: x0 => x0.buffer,
      _15: x0 => x0.wasmMemory,
      _16: () => globalThis.window._flutter_skwasmInstance,
      _17: x0 => x0.rasterStartMilliseconds,
      _18: x0 => x0.rasterEndMilliseconds,
      _19: x0 => x0.imageBitmaps,
      _192: x0 => x0.select(),
      _193: (x0,x1) => x0.append(x1),
      _194: x0 => x0.remove(),
      _197: x0 => x0.unlock(),
      _202: x0 => x0.getReader(),
      _211: x0 => new MutationObserver(x0),
      _222: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _223: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _226: x0 => new ResizeObserver(x0),
      _229: (x0,x1) => new Intl.Segmenter(x0,x1),
      _230: x0 => x0.next(),
      _231: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _308: x0 => x0.close(),
      _309: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      _310: x0 => new window.ImageDecoder(x0),
      _311: x0 => x0.close(),
      _312: x0 => ({frameIndex: x0}),
      _313: (x0,x1) => x0.decode(x1),
      _316: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._316(f,arguments.length,x0) }),
      _317: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._317(f,arguments.length,x0) }),
      _318: (x0,x1) => ({addView: x0,removeView: x1}),
      _319: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._319(f,arguments.length,x0) }),
      _320: f => finalizeWrapper(f, function() { return dartInstance.exports._320(f,arguments.length) }),
      _321: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _322: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._322(f,arguments.length,x0) }),
      _323: x0 => ({runApp: x0}),
      _324: x0 => new Uint8Array(x0),
      _326: x0 => x0.preventDefault(),
      _327: x0 => x0.stopPropagation(),
      _328: (x0,x1) => x0.addListener(x1),
      _329: (x0,x1) => x0.removeListener(x1),
      _330: (x0,x1) => x0.prepend(x1),
      _331: x0 => x0.remove(),
      _332: x0 => x0.disconnect(),
      _333: (x0,x1) => x0.addListener(x1),
      _334: (x0,x1) => x0.removeListener(x1),
      _336: (x0,x1) => x0.append(x1),
      _337: x0 => x0.remove(),
      _338: x0 => x0.stopPropagation(),
      _342: x0 => x0.preventDefault(),
      _343: (x0,x1) => x0.append(x1),
      _344: x0 => x0.remove(),
      _345: x0 => x0.preventDefault(),
      _350: (x0,x1) => x0.removeChild(x1),
      _351: (x0,x1) => x0.appendChild(x1),
      _352: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _353: (x0,x1) => x0.appendChild(x1),
      _354: (x0,x1) => x0.transferFromImageBitmap(x1),
      _356: (x0,x1) => x0.append(x1),
      _357: (x0,x1) => x0.append(x1),
      _358: (x0,x1) => x0.append(x1),
      _359: x0 => x0.remove(),
      _360: x0 => x0.remove(),
      _361: x0 => x0.remove(),
      _362: (x0,x1) => x0.appendChild(x1),
      _363: (x0,x1) => x0.appendChild(x1),
      _364: x0 => x0.remove(),
      _365: (x0,x1) => x0.append(x1),
      _366: (x0,x1) => x0.append(x1),
      _367: x0 => x0.remove(),
      _368: (x0,x1) => x0.append(x1),
      _369: (x0,x1) => x0.append(x1),
      _370: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _371: (x0,x1) => x0.append(x1),
      _372: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _373: x0 => x0.remove(),
      _374: x0 => x0.remove(),
      _375: (x0,x1) => x0.append(x1),
      _376: x0 => x0.remove(),
      _377: (x0,x1) => x0.append(x1),
      _378: x0 => x0.remove(),
      _379: x0 => x0.remove(),
      _380: x0 => x0.getBoundingClientRect(),
      _381: x0 => x0.remove(),
      _394: (x0,x1) => x0.append(x1),
      _395: x0 => x0.remove(),
      _396: (x0,x1) => x0.append(x1),
      _397: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _398: x0 => x0.preventDefault(),
      _399: x0 => x0.preventDefault(),
      _400: x0 => x0.preventDefault(),
      _401: x0 => x0.preventDefault(),
      _402: x0 => x0.remove(),
      _403: (x0,x1) => x0.observe(x1),
      _404: x0 => x0.disconnect(),
      _405: (x0,x1) => x0.appendChild(x1),
      _406: (x0,x1) => x0.appendChild(x1),
      _407: (x0,x1) => x0.appendChild(x1),
      _408: (x0,x1) => x0.append(x1),
      _409: x0 => x0.remove(),
      _410: (x0,x1) => x0.append(x1),
      _412: (x0,x1) => x0.appendChild(x1),
      _413: (x0,x1) => x0.append(x1),
      _414: x0 => x0.remove(),
      _415: (x0,x1) => x0.append(x1),
      _419: (x0,x1) => x0.appendChild(x1),
      _420: x0 => x0.remove(),
      _976: () => globalThis.window.flutterConfiguration,
      _977: x0 => x0.assetBase,
      _982: x0 => x0.debugShowSemanticsNodes,
      _983: x0 => x0.hostElement,
      _984: x0 => x0.multiViewEnabled,
      _985: x0 => x0.nonce,
      _987: x0 => x0.fontFallbackBaseUrl,
      _988: x0 => x0.useColorEmoji,
      _992: x0 => x0.console,
      _993: x0 => x0.devicePixelRatio,
      _994: x0 => x0.document,
      _995: x0 => x0.history,
      _996: x0 => x0.innerHeight,
      _997: x0 => x0.innerWidth,
      _998: x0 => x0.location,
      _999: x0 => x0.navigator,
      _1000: x0 => x0.visualViewport,
      _1001: x0 => x0.performance,
      _1004: (x0,x1) => x0.dispatchEvent(x1),
      _1005: (x0,x1) => x0.matchMedia(x1),
      _1007: (x0,x1) => x0.getComputedStyle(x1),
      _1008: x0 => x0.screen,
      _1009: (x0,x1) => x0.requestAnimationFrame(x1),
      _1010: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1010(f,arguments.length,x0) }),
      _1014: (x0,x1) => x0.warn(x1),
      _1017: () => globalThis.window,
      _1018: () => globalThis.Intl,
      _1019: () => globalThis.Symbol,
      _1022: x0 => x0.clipboard,
      _1023: x0 => x0.maxTouchPoints,
      _1024: x0 => x0.vendor,
      _1025: x0 => x0.language,
      _1026: x0 => x0.platform,
      _1027: x0 => x0.userAgent,
      _1028: x0 => x0.languages,
      _1029: x0 => x0.documentElement,
      _1030: (x0,x1) => x0.querySelector(x1),
      _1034: (x0,x1) => x0.createElement(x1),
      _1035: (x0,x1) => x0.execCommand(x1),
      _1039: (x0,x1) => x0.createTextNode(x1),
      _1040: (x0,x1) => x0.createEvent(x1),
      _1044: x0 => x0.head,
      _1045: x0 => x0.body,
      _1046: (x0,x1) => x0.title = x1,
      _1049: x0 => x0.activeElement,
      _1052: x0 => x0.visibilityState,
      _1053: x0 => x0.hasFocus(),
      _1054: () => globalThis.document,
      _1055: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1057: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1060: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1060(f,arguments.length,x0) }),
      _1061: x0 => x0.target,
      _1063: x0 => x0.timeStamp,
      _1064: x0 => x0.type,
      _1066: x0 => x0.preventDefault(),
      _1068: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _1074: x0 => x0.baseURI,
      _1075: x0 => x0.firstChild,
      _1080: x0 => x0.parentElement,
      _1082: x0 => x0.parentNode,
      _1085: (x0,x1) => x0.removeChild(x1),
      _1086: (x0,x1) => x0.removeChild(x1),
      _1087: x0 => x0.isConnected,
      _1088: (x0,x1) => x0.textContent = x1,
      _1090: (x0,x1) => x0.contains(x1),
      _1095: x0 => x0.firstElementChild,
      _1097: x0 => x0.nextElementSibling,
      _1098: x0 => x0.clientHeight,
      _1099: x0 => x0.clientWidth,
      _1100: x0 => x0.offsetHeight,
      _1101: x0 => x0.offsetWidth,
      _1102: x0 => x0.id,
      _1103: (x0,x1) => x0.id = x1,
      _1106: (x0,x1) => x0.spellcheck = x1,
      _1107: x0 => x0.tagName,
      _1108: x0 => x0.style,
      _1109: (x0,x1) => x0.append(x1),
      _1110: (x0,x1) => x0.getAttribute(x1),
      _1111: x0 => x0.getBoundingClientRect(),
      _1116: (x0,x1) => x0.closest(x1),
      _1119: (x0,x1) => x0.querySelectorAll(x1),
      _1121: x0 => x0.remove(),
      _1122: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1123: (x0,x1) => x0.removeAttribute(x1),
      _1124: (x0,x1) => x0.tabIndex = x1,
      _1126: (x0,x1) => x0.focus(x1),
      _1127: x0 => x0.scrollTop,
      _1128: (x0,x1) => x0.scrollTop = x1,
      _1129: x0 => x0.scrollLeft,
      _1130: (x0,x1) => x0.scrollLeft = x1,
      _1131: x0 => x0.classList,
      _1132: (x0,x1) => x0.className = x1,
      _1139: (x0,x1) => x0.getElementsByClassName(x1),
      _1141: x0 => x0.click(),
      _1143: (x0,x1) => x0.hasAttribute(x1),
      _1146: (x0,x1) => x0.attachShadow(x1),
      _1151: (x0,x1) => x0.getPropertyValue(x1),
      _1153: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _1155: (x0,x1) => x0.removeProperty(x1),
      _1157: x0 => x0.offsetLeft,
      _1158: x0 => x0.offsetTop,
      _1159: x0 => x0.offsetParent,
      _1161: (x0,x1) => x0.name = x1,
      _1162: x0 => x0.content,
      _1163: (x0,x1) => x0.content = x1,
      _1177: (x0,x1) => x0.nonce = x1,
      _1183: x0 => x0.now(),
      _1185: (x0,x1) => x0.width = x1,
      _1187: (x0,x1) => x0.height = x1,
      _1191: (x0,x1) => x0.getContext(x1),
      _1267: (x0,x1) => x0.fetch(x1),
      _1268: x0 => x0.status,
      _1269: x0 => x0.headers,
      _1270: x0 => x0.body,
      _1271: x0 => x0.arrayBuffer(),
      _1274: (x0,x1) => x0.get(x1),
      _1277: x0 => x0.read(),
      _1278: x0 => x0.value,
      _1279: x0 => x0.done,
      _1281: x0 => x0.name,
      _1282: x0 => x0.x,
      _1283: x0 => x0.y,
      _1286: x0 => x0.top,
      _1287: x0 => x0.right,
      _1288: x0 => x0.bottom,
      _1289: x0 => x0.left,
      _1299: x0 => x0.height,
      _1300: x0 => x0.width,
      _1301: (x0,x1) => x0.value = x1,
      _1303: (x0,x1) => x0.placeholder = x1,
      _1304: (x0,x1) => x0.name = x1,
      _1305: x0 => x0.selectionDirection,
      _1306: x0 => x0.selectionStart,
      _1307: x0 => x0.selectionEnd,
      _1310: x0 => x0.value,
      _1312: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1315: x0 => x0.readText(),
      _1316: (x0,x1) => x0.writeText(x1),
      _1317: x0 => x0.altKey,
      _1318: x0 => x0.code,
      _1319: x0 => x0.ctrlKey,
      _1320: x0 => x0.key,
      _1321: x0 => x0.keyCode,
      _1322: x0 => x0.location,
      _1323: x0 => x0.metaKey,
      _1324: x0 => x0.repeat,
      _1325: x0 => x0.shiftKey,
      _1326: x0 => x0.isComposing,
      _1327: (x0,x1) => x0.getModifierState(x1),
      _1329: x0 => x0.state,
      _1330: (x0,x1) => x0.go(x1),
      _1333: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1334: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1335: x0 => x0.pathname,
      _1336: x0 => x0.search,
      _1337: x0 => x0.hash,
      _1341: x0 => x0.state,
      _1347: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1347(f,arguments.length,x0,x1) }),
      _1350: (x0,x1,x2) => x0.observe(x1,x2),
      _1353: x0 => x0.attributeName,
      _1354: x0 => x0.type,
      _1355: x0 => x0.matches,
      _1358: x0 => x0.matches,
      _1360: x0 => x0.relatedTarget,
      _1361: x0 => x0.clientX,
      _1362: x0 => x0.clientY,
      _1363: x0 => x0.offsetX,
      _1364: x0 => x0.offsetY,
      _1367: x0 => x0.button,
      _1368: x0 => x0.buttons,
      _1369: x0 => x0.ctrlKey,
      _1370: (x0,x1) => x0.getModifierState(x1),
      _1373: x0 => x0.pointerId,
      _1374: x0 => x0.pointerType,
      _1375: x0 => x0.pressure,
      _1376: x0 => x0.tiltX,
      _1377: x0 => x0.tiltY,
      _1378: x0 => x0.getCoalescedEvents(),
      _1380: x0 => x0.deltaX,
      _1381: x0 => x0.deltaY,
      _1382: x0 => x0.wheelDeltaX,
      _1383: x0 => x0.wheelDeltaY,
      _1384: x0 => x0.deltaMode,
      _1390: x0 => x0.changedTouches,
      _1392: x0 => x0.clientX,
      _1393: x0 => x0.clientY,
      _1395: x0 => x0.data,
      _1398: (x0,x1) => x0.disabled = x1,
      _1399: (x0,x1) => x0.type = x1,
      _1400: (x0,x1) => x0.max = x1,
      _1401: (x0,x1) => x0.min = x1,
      _1402: (x0,x1) => x0.value = x1,
      _1403: x0 => x0.value,
      _1404: x0 => x0.disabled,
      _1405: (x0,x1) => x0.disabled = x1,
      _1406: (x0,x1) => x0.placeholder = x1,
      _1407: (x0,x1) => x0.name = x1,
      _1408: (x0,x1) => x0.autocomplete = x1,
      _1409: x0 => x0.selectionDirection,
      _1410: x0 => x0.selectionStart,
      _1411: x0 => x0.selectionEnd,
      _1415: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1420: (x0,x1) => x0.add(x1),
      _1423: (x0,x1) => x0.noValidate = x1,
      _1424: (x0,x1) => x0.method = x1,
      _1425: (x0,x1) => x0.action = x1,
      _1450: x0 => x0.orientation,
      _1451: x0 => x0.width,
      _1452: x0 => x0.height,
      _1453: (x0,x1) => x0.lock(x1),
      _1471: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1471(f,arguments.length,x0,x1) }),
      _1482: x0 => x0.length,
      _1483: (x0,x1) => x0.item(x1),
      _1484: x0 => x0.length,
      _1485: (x0,x1) => x0.item(x1),
      _1486: x0 => x0.iterator,
      _1487: x0 => x0.Segmenter,
      _1488: x0 => x0.v8BreakIterator,
      _1492: x0 => x0.done,
      _1493: x0 => x0.value,
      _1494: x0 => x0.index,
      _1498: (x0,x1) => x0.adoptText(x1),
      _1499: x0 => x0.first(),
      _1500: x0 => x0.next(),
      _1501: x0 => x0.current(),
      _1512: x0 => x0.hostElement,
      _1513: x0 => x0.viewConstraints,
      _1515: x0 => x0.maxHeight,
      _1516: x0 => x0.maxWidth,
      _1517: x0 => x0.minHeight,
      _1518: x0 => x0.minWidth,
      _1519: x0 => x0.loader,
      _1520: () => globalThis._flutter,
      _1521: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1522: (x0,x1,x2) => x0.call(x1,x2),
      _1523: () => globalThis.Promise,
      _1524: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1524(f,arguments.length,x0,x1) }),
      _1527: x0 => x0.length,
      _1530: x0 => x0.tracks,
      _1534: x0 => x0.image,
      _1539: x0 => x0.codedWidth,
      _1540: x0 => x0.codedHeight,
      _1543: x0 => x0.duration,
      _1547: x0 => x0.ready,
      _1548: x0 => x0.selectedTrack,
      _1549: x0 => x0.repetitionCount,
      _1550: x0 => x0.frameCount,
      _1632: (x0,x1) => x0.createElement(x1),
      _1649: (x0,x1,x2) => x0.createPolicy(x1,x2),
      _1674: x0 => globalThis.firebase_remote_config.fetchAndActivate(x0),
      _1676: (x0,x1) => globalThis.firebase_remote_config.getValue(x0,x1),
      _1677: x0 => x0.asString(),
      _1678: (x0,x1) => globalThis.firebase_remote_config.getValue(x0,x1),
      _1679: x0 => x0.getSource(),
      _1685: x0 => globalThis.firebase_remote_config.getRemoteConfig(x0),
      _1686: () => globalThis.Notification.requestPermission(),
      _1687: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1696: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _1699: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1701: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1703: (x0,x1) => x0.send(x1),
      _1712: (x0,x1) => x0.query(x1),
      _1713: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1713(f,arguments.length,x0) }),
      _1714: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1714(f,arguments.length,x0) }),
      _1715: (x0,x1,x2) => ({enableHighAccuracy: x0,timeout: x1,maximumAge: x2}),
      _1716: (x0,x1,x2,x3) => x0.getCurrentPosition(x1,x2,x3),
      _1722: (x0,x1,x2,x3) => globalThis.firebase_analytics.logEvent(x0,x1,x2,x3),
      _1728: (x0,x1) => globalThis.firebase_analytics.initializeAnalytics(x0,x1),
      _1745: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
      _1746: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      _1747: x0 => globalThis.firebase_core.getApp(x0),
      _1748: () => globalThis.firebase_core.getApp(),
      _1762: x0 => x0.settings,
      _1773: (x0,x1) => x0.minimumFetchIntervalMillis = x1,
      _1775: (x0,x1) => x0.fetchTimeoutMillis = x1,
      _1776: (x0,x1) => ({next: x0,error: x1}),
      _1778: x0 => globalThis.firebase_messaging.getMessaging(x0),
      _1780: (x0,x1) => globalThis.firebase_messaging.getToken(x0,x1),
      _1782: (x0,x1) => globalThis.firebase_messaging.onMessage(x0,x1),
      _1786: x0 => x0.title,
      _1787: x0 => x0.body,
      _1788: x0 => x0.image,
      _1789: x0 => x0.messageId,
      _1790: x0 => x0.collapseKey,
      _1791: x0 => x0.fcmOptions,
      _1792: x0 => x0.notification,
      _1793: x0 => x0.data,
      _1794: x0 => x0.from,
      _1795: x0 => x0.analyticsLabel,
      _1796: x0 => x0.link,
      _1797: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1797(f,arguments.length,x0) }),
      _1798: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1798(f,arguments.length,x0) }),
      _1801: () => globalThis.firebase_core.SDK_VERSION,
      _1808: x0 => x0.apiKey,
      _1810: x0 => x0.authDomain,
      _1812: x0 => x0.databaseURL,
      _1814: x0 => x0.projectId,
      _1816: x0 => x0.storageBucket,
      _1818: x0 => x0.messagingSenderId,
      _1820: x0 => x0.measurementId,
      _1822: x0 => x0.appId,
      _1824: x0 => x0.name,
      _1825: x0 => x0.options,
      _1834: (x0,x1) => x0.debug(x1),
      _1835: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1835(f,arguments.length,x0) }),
      _1836: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1836(f,arguments.length,x0,x1) }),
      _1837: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      _1838: (x0,x1) => x0.createScriptURL(x1),
      _1839: (x0,x1,x2) => x0.createScript(x1,x2),
      _1840: (x0,x1) => x0.appendChild(x1),
      _1841: (x0,x1) => x0.appendChild(x1),
      _1842: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1842(f,arguments.length,x0) }),
      _1843: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1844: (x0,x1) => x0.querySelector(x1),
      _1845: (x0,x1) => x0.append(x1),
      _1846: (x0,x1) => x0.querySelector(x1),
      _1847: (x0,x1) => x0.querySelector(x1),
      _1848: x0 => x0.remove(),
      _1849: (x0,x1) => x0.append(x1),
      _1850: (x0,x1) => x0.querySelector(x1),
      _1851: (x0,x1) => x0.getAttribute(x1),
      _1852: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1853: () => globalThis.removeSplashFromWeb(),
      _1867: x0 => new Array(x0),
      _1869: x0 => x0.length,
      _1871: (x0,x1) => x0[x1],
      _1872: (x0,x1,x2) => x0[x1] = x2,
      _1875: (x0,x1,x2) => new DataView(x0,x1,x2),
      _1877: x0 => new Int8Array(x0),
      _1878: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _1879: x0 => new Uint8Array(x0),
      _1887: x0 => new Int32Array(x0),
      _1889: x0 => new Uint32Array(x0),
      _1891: x0 => new Float32Array(x0),
      _1893: x0 => new Float64Array(x0),
      _1894: (o, t) => typeof o === t,
      _1895: (o, c) => o instanceof c,
      _1899: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1899(f,arguments.length,x0) }),
      _1900: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1900(f,arguments.length,x0) }),
      _1925: (decoder, codeUnits) => decoder.decode(codeUnits),
      _1926: () => new TextDecoder("utf-8", {fatal: true}),
      _1927: () => new TextDecoder("utf-8", {fatal: false}),
      _1928: x0 => new WeakRef(x0),
      _1929: x0 => x0.deref(),
      _1930: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1930(f,arguments.length,x0) }),
      _1931: x0 => new FinalizationRegistry(x0),
      _1932: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _1935: Date.now,
      _1937: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1938: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1939: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1940: () => typeof dartUseDateNowForTicks !== "undefined",
      _1941: () => 1000 * performance.now(),
      _1942: () => Date.now(),
      _1943: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _1944: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _1945: () => new WeakMap(),
      _1946: (map, o) => map.get(o),
      _1947: (map, o, v) => map.set(o, v),
      _1948: () => globalThis.WeakRef,
      _1952: () => globalThis.FinalizationRegistry,
      _1958: s => JSON.stringify(s),
      _1959: s => printToConsole(s),
      _1960: a => a.join(''),
      _1961: (o, a, b) => o.replace(a, b),
      _1963: (s, t) => s.split(t),
      _1964: s => s.toLowerCase(),
      _1965: s => s.toUpperCase(),
      _1966: s => s.trim(),
      _1967: s => s.trimLeft(),
      _1968: s => s.trimRight(),
      _1970: (s, p, i) => s.indexOf(p, i),
      _1971: (s, p, i) => s.lastIndexOf(p, i),
      _1972: (s) => s.replace(/\$/g, "$$$$"),
      _1973: Object.is,
      _1974: s => s.toUpperCase(),
      _1975: s => s.toLowerCase(),
      _1976: (a, i) => a.push(i),
      _1980: a => a.pop(),
      _1981: (a, i) => a.splice(i, 1),
      _1983: (a, s) => a.join(s),
      _1986: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1987: a => a.length,
      _1989: (a, i) => a[i],
      _1990: (a, i, v) => a[i] = v,
      _1992: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1993: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1994: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1995: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1996: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1997: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1998: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1999: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _2001: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _2002: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _2003: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _2004: (t, s) => t.set(s),
      _2005: l => new DataView(new ArrayBuffer(l)),
      _2006: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _2008: o => o.buffer,
      _2009: o => o.byteOffset,
      _2010: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _2011: (b, o) => new DataView(b, o),
      _2012: (b, o, l) => new DataView(b, o, l),
      _2013: Function.prototype.call.bind(DataView.prototype.getUint8),
      _2014: Function.prototype.call.bind(DataView.prototype.setUint8),
      _2015: Function.prototype.call.bind(DataView.prototype.getInt8),
      _2016: Function.prototype.call.bind(DataView.prototype.setInt8),
      _2017: Function.prototype.call.bind(DataView.prototype.getUint16),
      _2018: Function.prototype.call.bind(DataView.prototype.setUint16),
      _2019: Function.prototype.call.bind(DataView.prototype.getInt16),
      _2020: Function.prototype.call.bind(DataView.prototype.setInt16),
      _2021: Function.prototype.call.bind(DataView.prototype.getUint32),
      _2022: Function.prototype.call.bind(DataView.prototype.setUint32),
      _2023: Function.prototype.call.bind(DataView.prototype.getInt32),
      _2024: Function.prototype.call.bind(DataView.prototype.setInt32),
      _2027: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _2028: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _2029: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _2030: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _2031: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _2032: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _2045: () => new XMLHttpRequest(),
      _2046: (x0,x1,x2) => x0.open(x1,x2),
      _2047: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2048: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2049: x0 => x0.abort(),
      _2050: x0 => x0.abort(),
      _2051: x0 => x0.abort(),
      _2052: x0 => x0.abort(),
      _2053: x0 => x0.send(),
      _2055: x0 => x0.getAllResponseHeaders(),
      _2056: (o, t) => o instanceof t,
      _2058: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2058(f,arguments.length,x0) }),
      _2059: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2059(f,arguments.length,x0) }),
      _2060: o => Object.keys(o),
      _2061: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _2062: (handle) => clearTimeout(handle),
      _2063: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _2064: (handle) => clearInterval(handle),
      _2065: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _2066: () => Date.now(),
      _2067: (x0,x1,x2) => x0.transaction(x1,x2),
      _2068: (x0,x1) => x0.objectStore(x1),
      _2069: (x0,x1) => x0.getAllKeys(x1),
      _2070: (x0,x1) => x0.getAll(x1),
      _2072: (x0,x1) => x0.delete(x1),
      _2073: (x0,x1,x2) => x0.put(x1,x2),
      _2074: x0 => x0.clear(),
      _2075: x0 => x0.close(),
      _2077: (x0,x1,x2) => x0.open(x1,x2),
      _2082: (x0,x1) => x0.contains(x1),
      _2083: (x0,x1) => x0.createObjectStore(x1),
      _2084: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2084(f,arguments.length,x0) }),
      _2085: (x0,x1) => x0.contains(x1),
      _2086: (x0,x1) => x0.contains(x1),
      _2087: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2087(f,arguments.length,x0) }),
      _2118: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2118(f,arguments.length,x0) }),
      _2119: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2119(f,arguments.length,x0) }),
      _2120: x0 => x0.openCursor(),
      _2121: x0 => x0.continue(),
      _2122: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2122(f,arguments.length,x0) }),
      _2123: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2123(f,arguments.length,x0) }),
      _2124: () => new XMLHttpRequest(),
      _2125: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2126: x0 => x0.abort(),
      _2127: x0 => x0.getAllResponseHeaders(),
      _5184: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._5184(f,arguments.length,x0) }),
      _5185: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._5185(f,arguments.length,x0) }),
      _5195: x0 => x0.trustedTypes,
      _5197: (x0,x1) => x0.text = x1,
      _5213: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _5214: (x0,x1) => x0.exec(x1),
      _5215: (x0,x1) => x0.test(x1),
      _5216: (x0,x1) => x0.exec(x1),
      _5217: (x0,x1) => x0.exec(x1),
      _5218: x0 => x0.pop(),
      _5220: o => o === undefined,
      _5239: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _5241: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _5242: o => o instanceof RegExp,
      _5243: (l, r) => l === r,
      _5244: o => o,
      _5245: o => o,
      _5246: o => o,
      _5247: b => !!b,
      _5248: o => o.length,
      _5251: (o, i) => o[i],
      _5252: f => f.dartFunction,
      _5253: l => arrayFromDartList(Int8Array, l),
      _5254: l => arrayFromDartList(Uint8Array, l),
      _5255: l => arrayFromDartList(Uint8ClampedArray, l),
      _5256: l => arrayFromDartList(Int16Array, l),
      _5257: l => arrayFromDartList(Uint16Array, l),
      _5258: l => arrayFromDartList(Int32Array, l),
      _5259: l => arrayFromDartList(Uint32Array, l),
      _5260: l => arrayFromDartList(Float32Array, l),
      _5261: l => arrayFromDartList(Float64Array, l),
      _5262: x0 => new ArrayBuffer(x0),
      _5263: (data, length) => {
        const getValue = dartInstance.exports.$byteDataGetUint8;
        const view = new DataView(new ArrayBuffer(length));
        for (let i = 0; i < length; i++) {
          view.setUint8(i, getValue(data, i));
        }
        return view;
      },
      _5264: l => arrayFromDartList(Array, l),
      _5265: (s, length) => {
        if (length == 0) return '';
      
        const read = dartInstance.exports.$stringRead1;
        let result = '';
        let index = 0;
        const chunkLength = Math.min(length - index, 500);
        let array = new Array(chunkLength);
        while (index < length) {
          const newChunkLength = Math.min(length - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(s, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      _5266: (s, length) => {
        if (length == 0) return '';
      
        const read = dartInstance.exports.$stringRead2;
        let result = '';
        let index = 0;
        const chunkLength = Math.min(length - index, 500);
        let array = new Array(chunkLength);
        while (index < length) {
          const newChunkLength = Math.min(length - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(s, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      _5267: (s) => {
        let length = s.length;
        let range = 0;
        for (let i = 0; i < length; i++) {
          range |= s.codePointAt(i);
        }
        const exports = dartInstance.exports;
        if (range < 256) {
          if (length <= 10) {
            if (length == 1) {
              return exports.$stringAllocate1_1(s.codePointAt(0));
            }
            if (length == 2) {
              return exports.$stringAllocate1_2(s.codePointAt(0), s.codePointAt(1));
            }
            if (length == 3) {
              return exports.$stringAllocate1_3(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2));
            }
            if (length == 4) {
              return exports.$stringAllocate1_4(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3));
            }
            if (length == 5) {
              return exports.$stringAllocate1_5(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4));
            }
            if (length == 6) {
              return exports.$stringAllocate1_6(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5));
            }
            if (length == 7) {
              return exports.$stringAllocate1_7(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6));
            }
            if (length == 8) {
              return exports.$stringAllocate1_8(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6), s.codePointAt(7));
            }
            if (length == 9) {
              return exports.$stringAllocate1_9(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6), s.codePointAt(7), s.codePointAt(8));
            }
            if (length == 10) {
              return exports.$stringAllocate1_10(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6), s.codePointAt(7), s.codePointAt(8), s.codePointAt(9));
            }
          }
          const dartString = exports.$stringAllocate1(length);
          const write = exports.$stringWrite1;
          for (let i = 0; i < length; i++) {
            write(dartString, i, s.codePointAt(i));
          }
          return dartString;
        } else {
          const dartString = exports.$stringAllocate2(length);
          const write = exports.$stringWrite2;
          for (let i = 0; i < length; i++) {
            write(dartString, i, s.charCodeAt(i));
          }
          return dartString;
        }
      },
      _5268: () => ({}),
      _5269: () => [],
      _5270: l => new Array(l),
      _5271: () => globalThis,
      _5272: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _5273: (o, p) => p in o,
      _5274: (o, p) => o[p],
      _5275: (o, p, v) => o[p] = v,
      _5276: (o, m, a) => o[m].apply(o, a),
      _5278: o => String(o),
      _5279: (p, s, f) => p.then(s, f),
      _5280: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        return 17;
      },
      _5281: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5282: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5285: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5286: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5287: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5288: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5289: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5290: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5291: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _5293: x0 => x0.input,
      _5294: x0 => x0.index,
      _5300: x0 => x0.flags,
      _5301: x0 => x0.multiline,
      _5302: x0 => x0.ignoreCase,
      _5303: x0 => x0.unicode,
      _5304: x0 => x0.dotAll,
      _5305: (x0,x1) => x0.lastIndex = x1,
      _5306: (o, p) => p in o,
      _5307: (o, p) => o[p],
      _5308: (o, p, v) => o[p] = v,
      _5309: (o, p) => delete o[p],
      _5310: v => v.toString(),
      _5311: (d, digits) => d.toFixed(digits),
      _5315: x0 => x0.random(),
      _5316: x0 => x0.random(),
      _5317: (x0,x1) => x0.getRandomValues(x1),
      _5318: () => globalThis.crypto,
      _5320: () => globalThis.Math,
      _5444: x0 => x0.readyState,
      _5446: (x0,x1) => x0.timeout = x1,
      _5448: (x0,x1) => x0.withCredentials = x1,
      _5449: x0 => x0.upload,
      _5450: x0 => x0.responseURL,
      _5451: x0 => x0.status,
      _5452: x0 => x0.statusText,
      _5454: (x0,x1) => x0.responseType = x1,
      _5455: x0 => x0.response,
      _5469: x0 => x0.loaded,
      _5470: x0 => x0.total,
      _5750: (x0,x1) => x0.href = x1,
      _6780: (x0,x1) => x0.src = x1,
      _6782: (x0,x1) => x0.type = x1,
      _6786: (x0,x1) => x0.async = x1,
      _6790: (x0,x1) => x0.crossOrigin = x1,
      _6792: (x0,x1) => x0.text = x1,
      _7267: () => globalThis.window,
      _7309: x0 => x0.self,
      _7310: x0 => x0.document,
      _7313: x0 => x0.location,
      _7332: x0 => x0.navigator,
      _7589: x0 => x0.indexedDB,
      _7594: x0 => x0.trustedTypes,
      _7604: x0 => x0.href,
      _7704: x0 => x0.geolocation,
      _7707: x0 => x0.mediaDevices,
      _7709: x0 => x0.permissions,
      _7710: x0 => x0.maxTouchPoints,
      _7716: x0 => x0.deviceMemory,
      _7717: x0 => x0.appCodeName,
      _7718: x0 => x0.appName,
      _7719: x0 => x0.appVersion,
      _7720: x0 => x0.platform,
      _7721: x0 => x0.product,
      _7722: x0 => x0.productSub,
      _7723: x0 => x0.userAgent,
      _7724: x0 => x0.vendor,
      _7725: x0 => x0.vendorSub,
      _7727: x0 => x0.language,
      _7728: x0 => x0.languages,
      _7734: x0 => x0.hardwareConcurrency,
      _9927: x0 => x0.target,
      _10031: x0 => x0.baseURI,
      _10048: () => globalThis.document,
      _10141: x0 => x0.body,
      _10143: x0 => x0.head,
      _10492: (x0,x1) => x0.id = x1,
      _10515: x0 => x0.innerHTML,
      _10516: (x0,x1) => x0.innerHTML = x1,
      _13003: x0 => x0.state,
      _14076: x0 => x0.result,
      _14077: x0 => x0.error,
      _14082: (x0,x1) => x0.onsuccess = x1,
      _14084: (x0,x1) => x0.onerror = x1,
      _14088: (x0,x1) => x0.onupgradeneeded = x1,
      _14109: x0 => x0.version,
      _14110: x0 => x0.objectStoreNames,
      _14182: x0 => x0.key,
      _14185: x0 => x0.value,
      _14327: x0 => x0.coords,
      _14328: x0 => x0.timestamp,
      _14330: x0 => x0.accuracy,
      _14331: x0 => x0.latitude,
      _14332: x0 => x0.longitude,
      _14333: x0 => x0.altitude,
      _14334: x0 => x0.altitudeAccuracy,
      _14335: x0 => x0.heading,
      _14336: x0 => x0.speed,
      _14337: x0 => x0.code,
      _14338: x0 => x0.message,
      _16990: () => globalThis.console,
      _17023: x0 => x0.name,
      _17024: x0 => x0.message,
      _17025: x0 => x0.code,

    };

    const baseImports = {
      dart2wasm: dart2wasm,


      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
    };

    const deferredLibraryHelper = {
      "loadModule": async (moduleName) => {
        if (!loadDeferredWasm) {
          throw "No implementation of loadDeferredWasm provided.";
        }
        const source = await Promise.resolve(loadDeferredWasm(moduleName));
        const module = await ((source instanceof Response)
            ? WebAssembly.compileStreaming(source, this.builtins)
            : WebAssembly.compile(source, this.builtins));
        return await WebAssembly.instantiate(module, {
          ...baseImports,
          ...additionalImports,
          "wasm:js-string": jsStringPolyfill,
          "module0": dartInstance.exports,
        });
      },
    };

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      "deferredLibraryHelper": deferredLibraryHelper,
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}

