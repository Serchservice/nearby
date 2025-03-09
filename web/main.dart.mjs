
// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
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
      _3: (x0,x1) => x0.transferFromImageBitmap(x1),
      _4: x0 => x0.arrayBuffer(),
      _5: (x0,x1) => x0.transferFromImageBitmap(x1),
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
      _220: (x0,x1) => new OffscreenCanvas(x0,x1),
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
      _335: x0 => x0.blur(),
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
      _355: (x0,x1) => x0.appendChild(x1),
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
      _374: (x0,x1) => x0.append(x1),
      _375: x0 => x0.remove(),
      _376: (x0,x1) => x0.append(x1),
      _377: x0 => x0.remove(),
      _378: x0 => x0.remove(),
      _379: x0 => x0.getBoundingClientRect(),
      _380: x0 => x0.remove(),
      _393: (x0,x1) => x0.append(x1),
      _394: x0 => x0.remove(),
      _395: (x0,x1) => x0.append(x1),
      _396: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _397: x0 => x0.preventDefault(),
      _398: x0 => x0.preventDefault(),
      _399: x0 => x0.preventDefault(),
      _400: x0 => x0.preventDefault(),
      _401: (x0,x1) => x0.observe(x1),
      _402: x0 => x0.disconnect(),
      _403: (x0,x1) => x0.appendChild(x1),
      _404: (x0,x1) => x0.appendChild(x1),
      _405: (x0,x1) => x0.appendChild(x1),
      _406: (x0,x1) => x0.append(x1),
      _407: x0 => x0.remove(),
      _408: (x0,x1) => x0.append(x1),
      _409: (x0,x1) => x0.append(x1),
      _410: (x0,x1) => x0.appendChild(x1),
      _411: (x0,x1) => x0.append(x1),
      _412: x0 => x0.remove(),
      _413: (x0,x1) => x0.append(x1),
      _414: x0 => x0.remove(),
      _418: (x0,x1) => x0.appendChild(x1),
      _419: x0 => x0.remove(),
      _978: () => globalThis.window.flutterConfiguration,
      _979: x0 => x0.assetBase,
      _984: x0 => x0.debugShowSemanticsNodes,
      _985: x0 => x0.hostElement,
      _986: x0 => x0.multiViewEnabled,
      _987: x0 => x0.nonce,
      _989: x0 => x0.fontFallbackBaseUrl,
      _995: x0 => x0.console,
      _996: x0 => x0.devicePixelRatio,
      _997: x0 => x0.document,
      _998: x0 => x0.history,
      _999: x0 => x0.innerHeight,
      _1000: x0 => x0.innerWidth,
      _1001: x0 => x0.location,
      _1002: x0 => x0.navigator,
      _1003: x0 => x0.visualViewport,
      _1004: x0 => x0.performance,
      _1007: (x0,x1) => x0.dispatchEvent(x1),
      _1008: (x0,x1) => x0.matchMedia(x1),
      _1010: (x0,x1) => x0.getComputedStyle(x1),
      _1011: x0 => x0.screen,
      _1012: (x0,x1) => x0.requestAnimationFrame(x1),
      _1013: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1013(f,arguments.length,x0) }),
      _1018: (x0,x1) => x0.warn(x1),
      _1020: (x0,x1) => x0.debug(x1),
      _1021: () => globalThis.window,
      _1022: () => globalThis.Intl,
      _1023: () => globalThis.Symbol,
      _1026: x0 => x0.clipboard,
      _1027: x0 => x0.maxTouchPoints,
      _1028: x0 => x0.vendor,
      _1029: x0 => x0.language,
      _1030: x0 => x0.platform,
      _1031: x0 => x0.userAgent,
      _1032: x0 => x0.languages,
      _1033: x0 => x0.documentElement,
      _1034: (x0,x1) => x0.querySelector(x1),
      _1038: (x0,x1) => x0.createElement(x1),
      _1039: (x0,x1) => x0.execCommand(x1),
      _1042: (x0,x1) => x0.createTextNode(x1),
      _1043: (x0,x1) => x0.createEvent(x1),
      _1047: x0 => x0.head,
      _1048: x0 => x0.body,
      _1049: (x0,x1) => x0.title = x1,
      _1052: x0 => x0.activeElement,
      _1054: x0 => x0.visibilityState,
      _1056: x0 => x0.hasFocus(),
      _1057: () => globalThis.document,
      _1058: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1059: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1062: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1062(f,arguments.length,x0) }),
      _1063: x0 => x0.target,
      _1065: x0 => x0.timeStamp,
      _1066: x0 => x0.type,
      _1068: x0 => x0.preventDefault(),
      _1070: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _1076: x0 => x0.baseURI,
      _1077: x0 => x0.firstChild,
      _1082: x0 => x0.parentElement,
      _1084: x0 => x0.parentNode,
      _1088: (x0,x1) => x0.removeChild(x1),
      _1089: (x0,x1) => x0.removeChild(x1),
      _1090: x0 => x0.isConnected,
      _1091: (x0,x1) => x0.textContent = x1,
      _1095: (x0,x1) => x0.contains(x1),
      _1101: x0 => x0.firstElementChild,
      _1103: x0 => x0.nextElementSibling,
      _1104: x0 => x0.clientHeight,
      _1105: x0 => x0.clientWidth,
      _1106: x0 => x0.offsetHeight,
      _1107: x0 => x0.offsetWidth,
      _1108: x0 => x0.id,
      _1109: (x0,x1) => x0.id = x1,
      _1112: (x0,x1) => x0.spellcheck = x1,
      _1113: x0 => x0.tagName,
      _1114: x0 => x0.style,
      _1115: (x0,x1) => x0.append(x1),
      _1117: (x0,x1) => x0.getAttribute(x1),
      _1118: x0 => x0.getBoundingClientRect(),
      _1121: (x0,x1) => x0.closest(x1),
      _1124: (x0,x1) => x0.querySelectorAll(x1),
      _1126: x0 => x0.remove(),
      _1127: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1128: (x0,x1) => x0.removeAttribute(x1),
      _1129: (x0,x1) => x0.tabIndex = x1,
      _1132: (x0,x1) => x0.focus(x1),
      _1133: x0 => x0.scrollTop,
      _1134: (x0,x1) => x0.scrollTop = x1,
      _1135: x0 => x0.scrollLeft,
      _1136: (x0,x1) => x0.scrollLeft = x1,
      _1137: x0 => x0.classList,
      _1138: (x0,x1) => x0.className = x1,
      _1144: (x0,x1) => x0.getElementsByClassName(x1),
      _1146: x0 => x0.click(),
      _1147: (x0,x1) => x0.hasAttribute(x1),
      _1150: (x0,x1) => x0.attachShadow(x1),
      _1155: (x0,x1) => x0.getPropertyValue(x1),
      _1157: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _1159: (x0,x1) => x0.removeProperty(x1),
      _1161: x0 => x0.offsetLeft,
      _1162: x0 => x0.offsetTop,
      _1163: x0 => x0.offsetParent,
      _1165: (x0,x1) => x0.name = x1,
      _1166: x0 => x0.content,
      _1167: (x0,x1) => x0.content = x1,
      _1185: (x0,x1) => x0.nonce = x1,
      _1191: x0 => x0.now(),
      _1193: (x0,x1) => x0.width = x1,
      _1195: (x0,x1) => x0.height = x1,
      _1199: (x0,x1) => x0.getContext(x1),
      _1270: x0 => x0.width,
      _1271: x0 => x0.height,
      _1275: (x0,x1) => x0.fetch(x1),
      _1276: x0 => x0.status,
      _1277: x0 => x0.headers,
      _1278: x0 => x0.body,
      _1279: x0 => x0.arrayBuffer(),
      _1282: (x0,x1) => x0.get(x1),
      _1285: x0 => x0.read(),
      _1286: x0 => x0.value,
      _1287: x0 => x0.done,
      _1289: x0 => x0.name,
      _1290: x0 => x0.x,
      _1291: x0 => x0.y,
      _1294: x0 => x0.top,
      _1295: x0 => x0.right,
      _1296: x0 => x0.bottom,
      _1297: x0 => x0.left,
      _1306: x0 => x0.height,
      _1307: x0 => x0.width,
      _1308: (x0,x1) => x0.value = x1,
      _1310: (x0,x1) => x0.placeholder = x1,
      _1311: (x0,x1) => x0.name = x1,
      _1312: x0 => x0.selectionDirection,
      _1313: x0 => x0.selectionStart,
      _1314: x0 => x0.selectionEnd,
      _1317: x0 => x0.value,
      _1319: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1322: x0 => x0.readText(),
      _1323: (x0,x1) => x0.writeText(x1),
      _1324: x0 => x0.altKey,
      _1325: x0 => x0.code,
      _1326: x0 => x0.ctrlKey,
      _1327: x0 => x0.key,
      _1328: x0 => x0.keyCode,
      _1329: x0 => x0.location,
      _1330: x0 => x0.metaKey,
      _1331: x0 => x0.repeat,
      _1332: x0 => x0.shiftKey,
      _1333: x0 => x0.isComposing,
      _1334: (x0,x1) => x0.getModifierState(x1),
      _1336: x0 => x0.state,
      _1337: (x0,x1) => x0.go(x1),
      _1339: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1341: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1342: x0 => x0.pathname,
      _1343: x0 => x0.search,
      _1344: x0 => x0.hash,
      _1348: x0 => x0.state,
      _1356: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1356(f,arguments.length,x0,x1) }),
      _1358: (x0,x1,x2) => x0.observe(x1,x2),
      _1361: x0 => x0.attributeName,
      _1362: x0 => x0.type,
      _1363: x0 => x0.matches,
      _1366: x0 => x0.matches,
      _1368: x0 => x0.relatedTarget,
      _1369: x0 => x0.clientX,
      _1370: x0 => x0.clientY,
      _1371: x0 => x0.offsetX,
      _1372: x0 => x0.offsetY,
      _1375: x0 => x0.button,
      _1376: x0 => x0.buttons,
      _1377: x0 => x0.ctrlKey,
      _1378: (x0,x1) => x0.getModifierState(x1),
      _1381: x0 => x0.pointerId,
      _1382: x0 => x0.pointerType,
      _1383: x0 => x0.pressure,
      _1384: x0 => x0.tiltX,
      _1385: x0 => x0.tiltY,
      _1386: x0 => x0.getCoalescedEvents(),
      _1388: x0 => x0.deltaX,
      _1389: x0 => x0.deltaY,
      _1390: x0 => x0.wheelDeltaX,
      _1391: x0 => x0.wheelDeltaY,
      _1392: x0 => x0.deltaMode,
      _1398: x0 => x0.changedTouches,
      _1400: x0 => x0.clientX,
      _1401: x0 => x0.clientY,
      _1403: x0 => x0.data,
      _1406: (x0,x1) => x0.disabled = x1,
      _1407: (x0,x1) => x0.type = x1,
      _1408: (x0,x1) => x0.max = x1,
      _1409: (x0,x1) => x0.min = x1,
      _1410: (x0,x1) => x0.value = x1,
      _1411: x0 => x0.value,
      _1412: x0 => x0.disabled,
      _1413: (x0,x1) => x0.disabled = x1,
      _1414: (x0,x1) => x0.placeholder = x1,
      _1415: (x0,x1) => x0.name = x1,
      _1416: (x0,x1) => x0.autocomplete = x1,
      _1417: x0 => x0.selectionDirection,
      _1418: x0 => x0.selectionStart,
      _1419: x0 => x0.selectionEnd,
      _1423: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1428: (x0,x1) => x0.add(x1),
      _1432: (x0,x1) => x0.noValidate = x1,
      _1433: (x0,x1) => x0.method = x1,
      _1434: (x0,x1) => x0.action = x1,
      _1440: (x0,x1) => x0.getContext(x1),
      _1442: x0 => x0.convertToBlob(),
      _1459: x0 => x0.orientation,
      _1460: x0 => x0.width,
      _1461: x0 => x0.height,
      _1462: (x0,x1) => x0.lock(x1),
      _1478: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1478(f,arguments.length,x0,x1) }),
      _1489: x0 => x0.length,
      _1491: (x0,x1) => x0.item(x1),
      _1492: x0 => x0.length,
      _1493: (x0,x1) => x0.item(x1),
      _1494: x0 => x0.iterator,
      _1495: x0 => x0.Segmenter,
      _1496: x0 => x0.v8BreakIterator,
      _1499: x0 => x0.done,
      _1500: x0 => x0.value,
      _1501: x0 => x0.index,
      _1505: (x0,x1) => x0.adoptText(x1),
      _1506: x0 => x0.first(),
      _1507: x0 => x0.next(),
      _1508: x0 => x0.current(),
      _1522: x0 => x0.hostElement,
      _1523: x0 => x0.viewConstraints,
      _1525: x0 => x0.maxHeight,
      _1526: x0 => x0.maxWidth,
      _1527: x0 => x0.minHeight,
      _1528: x0 => x0.minWidth,
      _1529: x0 => x0.loader,
      _1530: () => globalThis._flutter,
      _1531: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1532: (x0,x1,x2) => x0.call(x1,x2),
      _1533: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1533(f,arguments.length,x0,x1) }),
      _1534: x0 => new Promise(x0),
      _1537: x0 => x0.length,
      _1540: x0 => x0.tracks,
      _1544: x0 => x0.image,
      _1551: x0 => x0.displayWidth,
      _1552: x0 => x0.displayHeight,
      _1553: x0 => x0.duration,
      _1556: x0 => x0.ready,
      _1557: x0 => x0.selectedTrack,
      _1558: x0 => x0.repetitionCount,
      _1559: x0 => x0.frameCount,
      _1622: (x0,x1) => x0.getUserMedia(x1),
      _1626: x0 => x0.getSupportedConstraints(),
      _1627: x0 => x0.getSettings(),
      _1628: x0 => x0.getCapabilities(),
      _1656: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1661: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _1668: x0 => ({type: x0}),
      _1669: (x0,x1) => new Blob(x0,x1),
      _1670: x0 => x0.getVideoTracks(),
      _1671: x0 => x0.stop(),
      _1672: x0 => x0.enumerateDevices(),
      _1673: x0 => x0.getVideoTracks(),
      _1674: x0 => x0.stop(),
      _1699: (x0,x1) => x0.createElement(x1),
      _1716: (x0,x1,x2) => x0.createPolicy(x1,x2),
      _1742: x0 => globalThis.firebase_remote_config.fetchAndActivate(x0),
      _1744: (x0,x1) => globalThis.firebase_remote_config.getValue(x0,x1),
      _1745: x0 => x0.asString(),
      _1746: (x0,x1) => globalThis.firebase_remote_config.getValue(x0,x1),
      _1747: x0 => x0.getSource(),
      _1754: x0 => globalThis.firebase_remote_config.getRemoteConfig(x0),
      _1755: () => globalThis.Notification.requestPermission(),
      _1756: x0 => x0.play(),
      _1757: x0 => x0.pause(),
      _1763: (x0,x1) => x0.removeAttribute(x1),
      _1764: x0 => x0.load(),
      _1765: (x0,x1) => x0.start(x1),
      _1766: (x0,x1) => x0.end(x1),
      _1768: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1769: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _1783: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1787: (x0,x1) => x0.send(x1),
      _1813: (x0,x1) => x0.query(x1),
      _1814: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1814(f,arguments.length,x0) }),
      _1815: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1815(f,arguments.length,x0) }),
      _1816: (x0,x1,x2) => ({enableHighAccuracy: x0,timeout: x1,maximumAge: x2}),
      _1817: (x0,x1,x2,x3) => x0.getCurrentPosition(x1,x2,x3),
      _1823: (x0,x1,x2,x3) => globalThis.firebase_analytics.logEvent(x0,x1,x2,x3),
      _1829: (x0,x1) => globalThis.firebase_analytics.initializeAnalytics(x0,x1),
      _1833: x0 => ({audio: x0}),
      _1834: x0 => x0.getAudioTracks(),
      _1835: x0 => x0.stop(),
      _1836: x0 => ({video: x0}),
      _1837: x0 => x0.getVideoTracks(),
      _1838: x0 => x0.stop(),
      _1839: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1839(f,arguments.length,x0) }),
      _1840: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1840(f,arguments.length,x0) }),
      _1841: (x0,x1,x2) => x0.getCurrentPosition(x1,x2),
      _1844: (x0,x1) => x0.querySelector(x1),
      _1845: (x0,x1) => x0.querySelector(x1),
      _1846: x0 => globalThis.URL.createObjectURL(x0),
      _1847: (x0,x1) => x0.item(x1),
      _1850: () => new FileReader(),
      _1851: (x0,x1) => x0.readAsArrayBuffer(x1),
      _1852: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1852(f,arguments.length,x0) }),
      _1853: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1853(f,arguments.length,x0) }),
      _1854: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1854(f,arguments.length,x0) }),
      _1855: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1855(f,arguments.length,x0) }),
      _1856: (x0,x1) => x0.removeChild(x1),
      _1857: x0 => x0.click(),
      _1858: (x0,x1) => x0.removeChild(x1),
      _1862: x0 => x0.deviceMemory,
      _1864: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
      _1865: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      _1866: x0 => globalThis.firebase_core.getApp(x0),
      _1867: () => globalThis.firebase_core.getApp(),
      _1882: x0 => x0.settings,
      _1893: (x0,x1) => x0.minimumFetchIntervalMillis = x1,
      _1895: (x0,x1) => x0.fetchTimeoutMillis = x1,
      _1896: (x0,x1) => ({next: x0,error: x1}),
      _1898: x0 => globalThis.firebase_messaging.getMessaging(x0),
      _1900: (x0,x1) => globalThis.firebase_messaging.getToken(x0,x1),
      _1902: (x0,x1) => globalThis.firebase_messaging.onMessage(x0,x1),
      _1906: x0 => x0.title,
      _1907: x0 => x0.body,
      _1908: x0 => x0.image,
      _1909: x0 => x0.messageId,
      _1910: x0 => x0.collapseKey,
      _1911: x0 => x0.fcmOptions,
      _1912: x0 => x0.notification,
      _1913: x0 => x0.data,
      _1914: x0 => x0.from,
      _1915: x0 => x0.analyticsLabel,
      _1916: x0 => x0.link,
      _1917: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1917(f,arguments.length,x0) }),
      _1918: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1918(f,arguments.length,x0) }),
      _1921: () => globalThis.firebase_core.SDK_VERSION,
      _1928: x0 => x0.apiKey,
      _1930: x0 => x0.authDomain,
      _1932: x0 => x0.databaseURL,
      _1934: x0 => x0.projectId,
      _1936: x0 => x0.storageBucket,
      _1938: x0 => x0.messagingSenderId,
      _1940: x0 => x0.measurementId,
      _1942: x0 => x0.appId,
      _1944: x0 => x0.name,
      _1945: x0 => x0.options,
      _1954: (x0,x1) => x0.debug(x1),
      _1955: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1955(f,arguments.length,x0) }),
      _1956: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1956(f,arguments.length,x0,x1) }),
      _1957: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      _1958: (x0,x1) => x0.createScriptURL(x1),
      _1959: (x0,x1,x2) => x0.createScript(x1,x2),
      _1960: (x0,x1) => x0.appendChild(x1),
      _1961: (x0,x1) => x0.appendChild(x1),
      _1962: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1962(f,arguments.length,x0) }),
      _1963: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1964: (x0,x1) => x0.querySelector(x1),
      _1965: (x0,x1) => x0.append(x1),
      _1966: (x0,x1) => x0.querySelector(x1),
      _1967: (x0,x1) => x0.querySelector(x1),
      _1968: x0 => x0.remove(),
      _1969: (x0,x1) => x0.append(x1),
      _1970: (x0,x1) => x0.querySelector(x1),
      _1971: (x0,x1) => x0.getAttribute(x1),
      _1972: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1973: () => globalThis.Intl.DateTimeFormat(),
      _1974: x0 => x0.resolvedOptions(),
      _1975: () => globalThis.Intl.supportedValuesOf,
      _1979: x0 => x0.timeZone,
      _1980: () => globalThis.removeSplashFromWeb(),
      _1981: (x0,x1) => ({video: x0,audio: x1}),
      _1994: x0 => new Array(x0),
      _1996: x0 => x0.length,
      _1998: (x0,x1) => x0[x1],
      _1999: (x0,x1,x2) => x0[x1] = x2,
      _2002: (x0,x1,x2) => new DataView(x0,x1,x2),
      _2004: x0 => new Int8Array(x0),
      _2005: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _2006: x0 => new Uint8Array(x0),
      _2012: x0 => new Uint16Array(x0),
      _2014: x0 => new Int32Array(x0),
      _2016: x0 => new Uint32Array(x0),
      _2018: x0 => new Float32Array(x0),
      _2020: x0 => new Float64Array(x0),
      _2021: (o, t) => typeof o === t,
      _2022: (o, c) => o instanceof c,
      _2026: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2026(f,arguments.length,x0) }),
      _2027: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2027(f,arguments.length,x0) }),
      _2031: (o, a) => o + a,
      _2052: (decoder, codeUnits) => decoder.decode(codeUnits),
      _2053: () => new TextDecoder("utf-8", {fatal: true}),
      _2054: () => new TextDecoder("utf-8", {fatal: false}),
      _2055: x0 => new WeakRef(x0),
      _2056: x0 => x0.deref(),
      _2057: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2057(f,arguments.length,x0) }),
      _2058: x0 => new FinalizationRegistry(x0),
      _2059: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _2062: Date.now,
      _2064: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _2065: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _2066: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _2067: () => typeof dartUseDateNowForTicks !== "undefined",
      _2068: () => 1000 * performance.now(),
      _2069: () => Date.now(),
      _2070: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _2071: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _2072: () => new WeakMap(),
      _2073: (map, o) => map.get(o),
      _2074: (map, o, v) => map.set(o, v),
      _2075: () => globalThis.WeakRef,
      _2079: () => globalThis.FinalizationRegistry,
      _2086: s => JSON.stringify(s),
      _2087: s => printToConsole(s),
      _2088: a => a.join(''),
      _2089: (o, a, b) => o.replace(a, b),
      _2091: (s, t) => s.split(t),
      _2092: s => s.toLowerCase(),
      _2093: s => s.toUpperCase(),
      _2094: s => s.trim(),
      _2095: s => s.trimLeft(),
      _2096: s => s.trimRight(),
      _2098: (s, p, i) => s.indexOf(p, i),
      _2099: (s, p, i) => s.lastIndexOf(p, i),
      _2100: (s) => s.replace(/\$/g, "$$$$"),
      _2101: Object.is,
      _2102: s => s.toUpperCase(),
      _2103: s => s.toLowerCase(),
      _2104: (a, i) => a.push(i),
      _2105: (a, i) => a.splice(i, 1)[0],
      _2108: a => a.pop(),
      _2109: (a, i) => a.splice(i, 1),
      _2111: (a, s) => a.join(s),
      _2114: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _2115: a => a.length,
      _2116: (a, l) => a.length = l,
      _2117: (a, i) => a[i],
      _2118: (a, i, v) => a[i] = v,
      _2120: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _2121: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _2122: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _2123: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _2124: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _2125: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _2126: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _2127: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _2129: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _2130: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _2131: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _2132: (t, s) => t.set(s),
      _2133: l => new DataView(new ArrayBuffer(l)),
      _2134: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _2136: o => o.buffer,
      _2137: o => o.byteOffset,
      _2138: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _2139: (b, o) => new DataView(b, o),
      _2140: (b, o, l) => new DataView(b, o, l),
      _2141: Function.prototype.call.bind(DataView.prototype.getUint8),
      _2142: Function.prototype.call.bind(DataView.prototype.setUint8),
      _2143: Function.prototype.call.bind(DataView.prototype.getInt8),
      _2144: Function.prototype.call.bind(DataView.prototype.setInt8),
      _2145: Function.prototype.call.bind(DataView.prototype.getUint16),
      _2146: Function.prototype.call.bind(DataView.prototype.setUint16),
      _2147: Function.prototype.call.bind(DataView.prototype.getInt16),
      _2148: Function.prototype.call.bind(DataView.prototype.setInt16),
      _2149: Function.prototype.call.bind(DataView.prototype.getUint32),
      _2150: Function.prototype.call.bind(DataView.prototype.setUint32),
      _2151: Function.prototype.call.bind(DataView.prototype.getInt32),
      _2152: Function.prototype.call.bind(DataView.prototype.setInt32),
      _2155: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _2156: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _2157: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _2158: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _2159: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _2160: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _2173: () => new XMLHttpRequest(),
      _2174: (x0,x1,x2) => x0.open(x1,x2),
      _2175: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2176: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2177: x0 => x0.abort(),
      _2178: x0 => x0.abort(),
      _2179: x0 => x0.abort(),
      _2180: x0 => x0.abort(),
      _2181: x0 => x0.send(),
      _2183: x0 => x0.getAllResponseHeaders(),
      _2184: (o, t) => o instanceof t,
      _2186: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2186(f,arguments.length,x0) }),
      _2187: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2187(f,arguments.length,x0) }),
      _2188: o => Object.keys(o),
      _2189: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _2190: (handle) => clearTimeout(handle),
      _2191: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _2192: (handle) => clearInterval(handle),
      _2193: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _2194: () => Date.now(),
      _2195: (x0,x1,x2) => x0.transaction(x1,x2),
      _2196: (x0,x1) => x0.objectStore(x1),
      _2197: (x0,x1) => x0.getAllKeys(x1),
      _2198: (x0,x1) => x0.getAll(x1),
      _2200: (x0,x1) => x0.delete(x1),
      _2201: (x0,x1,x2) => x0.put(x1,x2),
      _2203: x0 => x0.close(),
      _2205: (x0,x1,x2) => x0.open(x1,x2),
      _2210: (x0,x1) => x0.contains(x1),
      _2211: (x0,x1) => x0.createObjectStore(x1),
      _2212: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2212(f,arguments.length,x0) }),
      _2213: (x0,x1) => x0.contains(x1),
      _2214: (x0,x1) => x0.contains(x1),
      _2215: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2215(f,arguments.length,x0) }),
      _2246: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2246(f,arguments.length,x0) }),
      _2247: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2247(f,arguments.length,x0) }),
      _2248: x0 => x0.openCursor(),
      _2249: x0 => x0.continue(),
      _2250: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2250(f,arguments.length,x0) }),
      _2251: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2251(f,arguments.length,x0) }),
      _2252: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _2253: (x0,x1,x2) => x0.fetch(x1,x2),
      _2254: (x0,x1) => x0.get(x1),
      _2255: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._2255(f,arguments.length,x0,x1,x2) }),
      _2256: (x0,x1) => x0.forEach(x1),
      _2257: x0 => x0.abort(),
      _2258: () => new AbortController(),
      _2259: x0 => x0.getReader(),
      _2260: x0 => x0.read(),
      _2261: x0 => x0.cancel(),
      _5320: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._5320(f,arguments.length,x0) }),
      _5321: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._5321(f,arguments.length,x0) }),
      _5339: x0 => x0.facingMode,
      _5352: x0 => x0.trustedTypes,
      _5354: (x0,x1) => x0.text = x1,
      _5370: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _5371: (x0,x1) => x0.exec(x1),
      _5372: (x0,x1) => x0.test(x1),
      _5373: (x0,x1) => x0.exec(x1),
      _5374: (x0,x1) => x0.exec(x1),
      _5375: x0 => x0.pop(),
      _5377: o => o === undefined,
      _5396: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _5398: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _5399: o => o instanceof RegExp,
      _5400: (l, r) => l === r,
      _5401: o => o,
      _5402: o => o,
      _5403: o => o,
      _5404: b => !!b,
      _5405: o => o.length,
      _5408: (o, i) => o[i],
      _5409: f => f.dartFunction,
      _5410: l => arrayFromDartList(Int8Array, l),
      _5411: l => arrayFromDartList(Uint8Array, l),
      _5412: l => arrayFromDartList(Uint8ClampedArray, l),
      _5413: l => arrayFromDartList(Int16Array, l),
      _5414: l => arrayFromDartList(Uint16Array, l),
      _5415: l => arrayFromDartList(Int32Array, l),
      _5416: l => arrayFromDartList(Uint32Array, l),
      _5417: l => arrayFromDartList(Float32Array, l),
      _5418: l => arrayFromDartList(Float64Array, l),
      _5419: x0 => new ArrayBuffer(x0),
      _5420: (data, length) => {
        const getValue = dartInstance.exports.$byteDataGetUint8;
        const view = new DataView(new ArrayBuffer(length));
        for (let i = 0; i < length; i++) {
          view.setUint8(i, getValue(data, i));
        }
        return view;
      },
      _5421: l => arrayFromDartList(Array, l),
      _5422: () => ({}),
      _5423: () => [],
      _5424: l => new Array(l),
      _5425: () => globalThis,
      _5426: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _5427: (o, p) => p in o,
      _5428: (o, p) => o[p],
      _5429: (o, p, v) => o[p] = v,
      _5430: (o, m, a) => o[m].apply(o, a),
      _5432: o => String(o),
      _5433: (p, s, f) => p.then(s, f),
      _5434: o => {
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
      _5435: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5436: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5437: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5438: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5439: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5440: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5441: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5442: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5443: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _5444: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _5445: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _5448: x0 => x0.index,
      _5453: x0 => x0.flags,
      _5454: x0 => x0.multiline,
      _5455: x0 => x0.ignoreCase,
      _5456: x0 => x0.unicode,
      _5457: x0 => x0.dotAll,
      _5458: (x0,x1) => x0.lastIndex = x1,
      _5459: (o, p) => p in o,
      _5460: (o, p) => o[p],
      _5461: (o, p, v) => o[p] = v,
      _5462: (o, p) => delete o[p],
      _5463: x0 => x0.random(),
      _5464: x0 => x0.random(),
      _5465: (x0,x1) => x0.getRandomValues(x1),
      _5466: () => globalThis.crypto,
      _5468: () => globalThis.Math,
      _5470: Function.prototype.call.bind(Number.prototype.toString),
      _5471: (d, digits) => d.toFixed(digits),
      _5611: x0 => x0.readyState,
      _5613: (x0,x1) => x0.timeout = x1,
      _5615: (x0,x1) => x0.withCredentials = x1,
      _5616: x0 => x0.upload,
      _5617: x0 => x0.responseURL,
      _5618: x0 => x0.status,
      _5619: x0 => x0.statusText,
      _5621: (x0,x1) => x0.responseType = x1,
      _5622: x0 => x0.response,
      _5636: x0 => x0.loaded,
      _5637: x0 => x0.total,
      _5686: (x0,x1) => x0.draggable = x1,
      _5702: x0 => x0.style,
      _5917: (x0,x1) => x0.href = x1,
      _6275: x0 => x0.videoWidth,
      _6276: x0 => x0.videoHeight,
      _6280: (x0,x1) => x0.playsInline = x1,
      _6309: x0 => x0.error,
      _6311: (x0,x1) => x0.src = x1,
      _6320: x0 => x0.buffered,
      _6323: x0 => x0.currentTime,
      _6324: (x0,x1) => x0.currentTime = x1,
      _6325: x0 => x0.duration,
      _6330: (x0,x1) => x0.playbackRate = x1,
      _6337: (x0,x1) => x0.autoplay = x1,
      _6339: (x0,x1) => x0.loop = x1,
      _6341: (x0,x1) => x0.controls = x1,
      _6343: (x0,x1) => x0.volume = x1,
      _6345: (x0,x1) => x0.muted = x1,
      _6360: x0 => x0.code,
      _6361: x0 => x0.message,
      _6437: x0 => x0.length,
      _6634: (x0,x1) => x0.accept = x1,
      _6648: x0 => x0.files,
      _6674: (x0,x1) => x0.multiple = x1,
      _6692: (x0,x1) => x0.type = x1,
      _6947: (x0,x1) => x0.src = x1,
      _6949: (x0,x1) => x0.type = x1,
      _6953: (x0,x1) => x0.async = x1,
      _6957: (x0,x1) => x0.crossOrigin = x1,
      _6959: (x0,x1) => x0.text = x1,
      _7434: () => globalThis.window,
      _7475: x0 => x0.self,
      _7476: x0 => x0.document,
      _7479: x0 => x0.location,
      _7498: x0 => x0.navigator,
      _7755: x0 => x0.indexedDB,
      _7760: x0 => x0.trustedTypes,
      _7770: x0 => x0.href,
      _7870: x0 => x0.geolocation,
      _7873: x0 => x0.mediaDevices,
      _7875: x0 => x0.permissions,
      _7876: x0 => x0.maxTouchPoints,
      _7883: x0 => x0.appCodeName,
      _7884: x0 => x0.appName,
      _7885: x0 => x0.appVersion,
      _7886: x0 => x0.platform,
      _7887: x0 => x0.product,
      _7888: x0 => x0.productSub,
      _7889: x0 => x0.userAgent,
      _7890: x0 => x0.vendor,
      _7891: x0 => x0.vendorSub,
      _7893: x0 => x0.language,
      _7894: x0 => x0.languages,
      _7900: x0 => x0.hardwareConcurrency,
      _10093: x0 => x0.target,
      _10135: x0 => x0.signal,
      _10197: x0 => x0.baseURI,
      _10203: x0 => x0.firstChild,
      _10214: () => globalThis.document,
      _10307: x0 => x0.body,
      _10309: x0 => x0.head,
      _10658: (x0,x1) => x0.id = x1,
      _10681: x0 => x0.innerHTML,
      _10682: (x0,x1) => x0.innerHTML = x1,
      _10685: x0 => x0.children,
      _12039: x0 => x0.value,
      _12041: x0 => x0.done,
      _12227: x0 => x0.size,
      _12228: x0 => x0.type,
      _12235: x0 => x0.name,
      _12242: x0 => x0.length,
      _12253: x0 => x0.result,
      _12761: x0 => x0.url,
      _12763: x0 => x0.status,
      _12765: x0 => x0.statusText,
      _12766: x0 => x0.headers,
      _12767: x0 => x0.body,
      _13166: x0 => x0.state,
      _13572: x0 => x0.active,
      _13607: x0 => x0.facingMode,
      _13682: x0 => x0.facingMode,
      _13908: x0 => x0.deviceId,
      _13909: x0 => x0.kind,
      _13910: x0 => x0.label,
      _14239: x0 => x0.result,
      _14240: x0 => x0.error,
      _14245: (x0,x1) => x0.onsuccess = x1,
      _14247: (x0,x1) => x0.onerror = x1,
      _14251: (x0,x1) => x0.onupgradeneeded = x1,
      _14272: x0 => x0.version,
      _14273: x0 => x0.objectStoreNames,
      _14345: x0 => x0.key,
      _14348: x0 => x0.value,
      _14490: x0 => x0.coords,
      _14491: x0 => x0.timestamp,
      _14493: x0 => x0.accuracy,
      _14494: x0 => x0.latitude,
      _14495: x0 => x0.longitude,
      _14496: x0 => x0.altitude,
      _14497: x0 => x0.altitudeAccuracy,
      _14498: x0 => x0.heading,
      _14499: x0 => x0.speed,
      _14500: x0 => x0.code,
      _14501: x0 => x0.message,
      _14916: (x0,x1) => x0.border = x1,
      _15194: (x0,x1) => x0.display = x1,
      _15358: (x0,x1) => x0.height = x1,
      _16048: (x0,x1) => x0.width = x1,
      _16425: x0 => x0.name,
      _16426: x0 => x0.message,
      _17153: () => globalThis.console,
      _17186: x0 => x0.name,
      _17187: x0 => x0.message,
      _17188: x0 => x0.code,

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
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
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

