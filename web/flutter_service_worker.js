'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon-16x16.png": "8709043e1c96334486ad8310e17bdd65",
"flutter_bootstrap.js": "249c2bf87a8f8d026a70d19afe8b8de4",
"version.json": "3731ab739ebc337bdb2a16c68ed4e031",
"splash/img/light-2x.png": "284c966aab9211b8badf8a1239dae583",
"splash/img/branding-4x.png": "9b58285fa1445e36193307caf713de18",
"splash/img/dark-4x.png": "7172b78037af7708b9420a7475490e2b",
"splash/img/branding-dark-1x.png": "1b1e4cc68b717222d6e4cc7e1a193756",
"splash/img/light-3x.png": "c718c9d57f33c4d8fb23f1376cea29fd",
"splash/img/dark-3x.png": "c718c9d57f33c4d8fb23f1376cea29fd",
"splash/img/light-4x.png": "7172b78037af7708b9420a7475490e2b",
"splash/img/branding-2x.png": "734c2fb0691d684f38dfeec15889df79",
"splash/img/branding-3x.png": "0514097ef868f641440c279511860847",
"splash/img/dark-2x.png": "284c966aab9211b8badf8a1239dae583",
"splash/img/dark-1x.png": "58bfebaee24e7dc635470e346afe7328",
"splash/img/branding-dark-4x.png": "9b58285fa1445e36193307caf713de18",
"splash/img/branding-1x.png": "1b1e4cc68b717222d6e4cc7e1a193756",
"splash/img/branding-dark-2x.png": "734c2fb0691d684f38dfeec15889df79",
"splash/img/light-1x.png": "58bfebaee24e7dc635470e346afe7328",
"splash/img/branding-dark-3x.png": "0514097ef868f641440c279511860847",
"favicon.ico": "333d96091655a148ffff0f5321425a87",
"index.html": "e127f670d31b67b2c0dcf121b7b8f0cf",
"/": "e127f670d31b67b2c0dcf121b7b8f0cf",
"android-chrome-192x192.png": "a5911b19d47e3ae4a6c179fdbb908b6a",
"apple-touch-icon.png": "e5c7df3135edfda165140881249b3968",
"main.dart.js": "e1c2d7a775b84bdcdc5e523ed4585526",
"ads.txt": "c1bbee77aeb0be796c2bcc819078fee5",
".well-known/apple-app-site-association.json": "534b17c09945587b16f3c65598744053",
".well-known/assetlinks.json": "8b6319ea448b82e857b278cb9e710ab5",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.mjs": "602a3ac16f6e474a7d53de46c9a625b8",
"android-chrome-512x512.png": "d178682e9600515b269736c566c6c3ee",
"site.webmanifest": "053100cb84a50d2ae7f5492f7dd7f25e",
"icons/Icon-192.png": "85718d5d506e762608c3077eab08f307",
"icons/Icon-maskable-192.png": "85718d5d506e762608c3077eab08f307",
"icons/Icon-maskable-512.png": "c45d690e05fd0307ce7ac65388f8362f",
"icons/Icon-512.png": "c45d690e05fd0307ce7ac65388f8362f",
"manifest.json": "ee43f8a69c074143a697b39d82584756",
"main.dart.wasm": "4dffd5075d3a50f2e584b195d43d9093",
"assets/asset/app/user.png": "198f4d4fcc319e7ab94a7d1df8b6f2f1",
"assets/asset/app/business.png": "ce352d15f6a433d55c24d9e9b685ba05",
"assets/asset/app/provider.png": "e8955eb4aaf3fb60970e4857e628cafb",
"assets/asset/common/drive-car-white-reverse.png": "056d1665554167ecacdb9c210bbf55bf",
"assets/asset/common/drive-white.png": "e61bea6b7c46b802c12fc62b533a1a60",
"assets/asset/common/drive-car-white.png": "9df6f3b66cfbbd1c525e226a185a2930",
"assets/asset/common/drive-white-reverse.png": "ba6a7967d89a0929f751592558c5041c",
"assets/asset/common/google_map_style.json": "0bc926b57222d37e93dbd2d63372f404",
"assets/asset/common/drive-car-black-reverse.png": "e8103b8149b7fdb3fbf858caa4fd7cc3",
"assets/asset/common/drive-black.png": "100d66fb51969229c867d25cc30522d7",
"assets/asset/common/drive-black-reverse.png": "548957505304f0dbd05ee4a4222de7b0",
"assets/asset/common/drive-car-black.png": "e265e0382d8ce8528e52724501eff77c",
"assets/asset/map/world.png": "cc972b14e76da37a89aa682ec523579c",
"assets/asset/map/fly.png": "087023dc77d6cf6b1ac2abfe5c25152f",
"assets/asset/map/openstreetmap.png": "ed886fab8c104191559683c7753f1292",
"assets/asset/map/destination.png": "83e4dea4f5febacc0404cf85a93ac9c3",
"assets/asset/map/google-maps.png": "30f0baf2a9e5ee0251fe7d7026e74ceb",
"assets/asset/map/up-right.png": "442fbd8120ae812a2a15f9d0dcac7afa",
"assets/asset/map/map-right.png": "55f53a18e6f097a64cf9fff2329e37c5",
"assets/asset/map/drive.png": "8d0088dcfdb6f048bf4c143732147d0b",
"assets/asset/map/location.png": "3bb67badf1820534c9763b8c7fc129d0",
"assets/asset/map/current.png": "34970dac4afe79f9695695f499704c3f",
"assets/asset/map/bing.png": "ea9bdeeae4e415fe5f3e28f4186991cf",
"assets/asset/logo/splash-screen-android-12.png": "a1eaa3c77d2bfcddfeee4ffb288e464d",
"assets/asset/logo/info.png": "e88c5983f52f1f24295912da4889c7ce",
"assets/asset/logo/512Background.png": "1aa3ea798e4718984b9c7622f2bf171d",
"assets/asset/logo/760Background.png": "41597fece9a4bbc64b0f84edc8c63c5c",
"assets/asset/logo/branding-android-12.png": "b02059c1cf66152286898c0220e4bbcf",
"assets/asset/logo/1080Background.png": "c508d9e14c1b398ff8a935c137a02d00",
"assets/asset/logo/512Transparent.png": "efb7d0165d02bd27484646dbbb73aef8",
"assets/asset/logo/logo.png": "544704f292e0b4cb9914027e748dada1",
"assets/asset/logo/app-icon.png": "96fe50484dc43fba4ddf475debeb9a6e",
"assets/asset/logo/splash-screen.png": "e7c298b2edeb29617ef93ef6ddd28ac1",
"assets/asset/logo/branding-android.png": "5da25e6b52afbcedf328f3619516c9f8",
"assets/asset/theme/window_dark.png": "c4d0bd15571a42340352bb4cb8cd0308",
"assets/asset/theme/window_light.png": "9013d43b9f141c3bf3b6e3a4ecac5a88",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-Medium.ttf": "b2e26657bde91d3d3f4dbc4d7010197e",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-ExtraBold.ttf": "e1e49dc3541972f5b7c26df8a5ae5d9a",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-VariableFont_wght.ttf": "74e0325138e01274149c3edf123360c5",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-Black.ttf": "76fd2f6ac13db0b5f3e173717c765b85",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-ExtraLight.ttf": "61843bae8d85e850a2b9e39fdf29dc7f",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-Regular.ttf": "a81ff45ebf2f1aa10df144b7a407926a",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-Light.ttf": "c71b849419d6561a570a89eb8debce8c",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-Thin.ttf": "d9ae2037448184a8927bd7d8748a53b2",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-SemiBold.ttf": "f1f514ca0d30100d42e8414b84eac0be",
"assets/asset/fonts/LeagueSpartan/LeagueSpartan-Bold.ttf": "9a223d8a028354713a4a4072dc19250a",
"assets/asset/fonts/Nunito/Nunito-Medium.ttf": "d26cecc95cdc8327b337357e6c5c1f5b",
"assets/asset/fonts/Nunito/Nunito-ExtraBoldItalic.ttf": "e01118312e526f062fc8ad8f3c64de0e",
"assets/asset/fonts/Nunito/Nunito-ExtraBold.ttf": "5b5a206f5cd32fa496c93925d0caf609",
"assets/asset/fonts/Nunito/Nunito-ExtraLightItalic.ttf": "f9088a8e7dae2fc4e88975f6e1726c93",
"assets/asset/fonts/Nunito/Nunito-VariableFont_wght.ttf": "ea0ad4c72a135f9a43ec7bb83f2469aa",
"assets/asset/fonts/Nunito/Nunito-Light.ttf": "7de99c591b88e33ceda578f9ee140263",
"assets/asset/fonts/Nunito/Nunito-Regular.ttf": "b83ce9c59c73ade26bb7871143fd76bb",
"assets/asset/fonts/Nunito/Nunito-SemiBold.ttf": "38257ec36f55676f98fcdf1264adb69d",
"assets/asset/fonts/Nunito/Nunito-Bold.ttf": "ba43cdecf9625c0dcec567ba29555e15",
"assets/asset/fonts/Nunito/Nunito-BoldItalic.ttf": "dc69781f4856bdb711087d1ae07ca208",
"assets/asset/fonts/Nunito/Nunito-Black.ttf": "27ee28fd596c0bd4235fa792d0d8b1ce",
"assets/asset/fonts/Nunito/Nunito-ExtraLight.ttf": "ef7ff1b92707646c2e02a39067aab385",
"assets/asset/fonts/Nunito/Nunito-SemiBoldItalic.ttf": "4c2772c15392fbfdb077342b7851f66c",
"assets/asset/fonts/Nunito/Nunito-BlackItalic.ttf": "47e66b00cd98f1925da80dd6b7ff29a1",
"assets/asset/fonts/Nunito/Nunito-Italic-VariableFont_wght.ttf": "14e83abff83f855acdf3bfd30da3ad79",
"assets/asset/fonts/Nunito/Nunito-Italic.ttf": "fac5c8ffb51e06094affdbb7fff9000e",
"assets/asset/fonts/Nunito/Nunito-LightItalic.ttf": "cdf25a6c9cbb6def64afcc30d3e511b9",
"assets/asset/fonts/Nunito/Nunito-MediumItalic.ttf": "bd282ec988480f875b2f7cb0465ff7fa",
"assets/AssetManifest.json": "12760c2b70b4baac44f07c832f85d2ad",
"assets/NOTICES": "61a35351207c625769115220e2fadaf2",
"assets/FontManifest.json": "d81856f216b77c56f72f651bf103636d",
"assets/AssetManifest.bin.json": "3eead360fdc67a3db1706a59d0547ec2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "ca594aa346bc4e371fb52c7905c4088f",
"assets/packages/map_launcher/assets/icons/mappls.svg": "1a75722e15a1700115955325fe34502b",
"assets/packages/map_launcher/assets/icons/citymapper.svg": "58c49ff6df286e325c21a28ebf783ebe",
"assets/packages/map_launcher/assets/icons/sygicTruck.svg": "242728853b652fa765de8fba7ecd250f",
"assets/packages/map_launcher/assets/icons/naver.svg": "ef3ef5881d4a2beb187dfc87e23b6133",
"assets/packages/map_launcher/assets/icons/tencent.svg": "4e1babec6bbab0159bdc204932193a89",
"assets/packages/map_launcher/assets/icons/copilot.svg": "b412a5f02e8cef01cdb684b03834cc03",
"assets/packages/map_launcher/assets/icons/truckmeister.svg": "416d2d7d2be53cd772bc59b910082a5b",
"assets/packages/map_launcher/assets/icons/yandexNavi.svg": "bad6bf6aebd1e0d711f3c7ed9497e9a3",
"assets/packages/map_launcher/assets/icons/yandexMaps.svg": "3dfd1d365352408e86c9c57fef238eed",
"assets/packages/map_launcher/assets/icons/tmap.svg": "50c98b143eb16f802a756294ed04b200",
"assets/packages/map_launcher/assets/icons/petal.svg": "76c9cfa1bfefb298416cfef6a13a70c5",
"assets/packages/map_launcher/assets/icons/doubleGis.svg": "ab8f52395c01fcd87ed3e2ed9660966e",
"assets/packages/map_launcher/assets/icons/here.svg": "aea2492cde15953de7bb2ab1487fd4c7",
"assets/packages/map_launcher/assets/icons/tomtomgofleet.svg": "5b12dcb09ec0a67934e6586da67a0149",
"assets/packages/map_launcher/assets/icons/mapswithme.svg": "87df7956e58cae949e88a0c744ca49e8",
"assets/packages/map_launcher/assets/icons/osmandplus.svg": "31c36b1f20dc45a88c283e928583736f",
"assets/packages/map_launcher/assets/icons/google.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/googleGo.svg": "cb318c1fc31719ceda4073d8ca38fc1e",
"assets/packages/map_launcher/assets/icons/mapyCz.svg": "f5a198b01f222b1201e826495661008c",
"assets/packages/map_launcher/assets/icons/kakao.svg": "1c7c75914d64033825ffc0ff2bdbbb58",
"assets/packages/map_launcher/assets/icons/osmand.svg": "639b2304776a6794ec682a926dbcbc4c",
"assets/packages/map_launcher/assets/icons/tomtomgo.svg": "493b0844a3218a19b1c80c92c060bba7",
"assets/packages/map_launcher/assets/icons/flitsmeister.svg": "44ba265e6077dd5bf98668dc2b8baec1",
"assets/packages/map_launcher/assets/icons/baidu.svg": "22335d62432f9d5aac833bcccfa5cfe8",
"assets/packages/map_launcher/assets/icons/apple.svg": "6fe49a5ae50a4c603897f6f54dec16a8",
"assets/packages/map_launcher/assets/icons/waze.svg": "311a17de2a40c8fa1dd9022d4e12982c",
"assets/packages/map_launcher/assets/icons/amap.svg": "00409535b144c70322cd4600de82657c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "e210c70ff9c7ef3ca0ce6fdd3bb8ab50",
"assets/fonts/MaterialIcons-Regular.otf": "fb85ced394e6c72f77983c342e617b8a",
"favicon-32x32.png": "d0d05f28f18fa6df6cc02f3609d9ee2e",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
