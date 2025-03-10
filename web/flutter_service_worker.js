'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon-16x16.png": "8709043e1c96334486ad8310e17bdd65",
"flutter_bootstrap.js": "316bd94df3cf22c27ccb53836b3c9c32",
"version.json": "8c670dafb4c4d7a69d975aa688428c6a",
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
"index.html": "c711fa396fcd6e1bc38d8b5c9e00f457",
"/": "c711fa396fcd6e1bc38d8b5c9e00f457",
"android-chrome-192x192.png": "a5911b19d47e3ae4a6c179fdbb908b6a",
"apple-touch-icon.png": "e5c7df3135edfda165140881249b3968",
"main.dart.js": "2615b9aa722fba5eb442503d22948a7f",
"ads.txt": "c1bbee77aeb0be796c2bcc819078fee5",
".well-known/apple-app-site-association.json": "534b17c09945587b16f3c65598744053",
".well-known/assetlinks.json": "8b6319ea448b82e857b278cb9e710ab5",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"android-chrome-512x512.png": "d178682e9600515b269736c566c6c3ee",
"icons/Icon-192.png": "85718d5d506e762608c3077eab08f307",
"icons/Icon-maskable-192.png": "85718d5d506e762608c3077eab08f307",
"icons/Icon-maskable-512.png": "c45d690e05fd0307ce7ac65388f8362f",
"icons/Icon-512.png": "c45d690e05fd0307ce7ac65388f8362f",
"manifest.json": "053be76bf1609cf612bc91b63bed3b32",
"assets/asset/anim/go.png": "843a67b69a784e6d1ad05c2f4ddf68a3",
"assets/asset/anim/wired.png": "87499cda2df69457e1154989091ea947",
"assets/asset/anim/go_beyond.png": "9f8dcbdfbb03525884e05ddea60c7313",
"assets/asset/logo/splash-screen-android-12.png": "a1eaa3c77d2bfcddfeee4ffb288e464d",
"assets/asset/logo/info.png": "e88c5983f52f1f24295912da4889c7ce",
"assets/asset/logo/512Background.png": "1aa3ea798e4718984b9c7622f2bf171d",
"assets/asset/logo/760Background.png": "41597fece9a4bbc64b0f84edc8c63c5c",
"assets/asset/logo/branding-android-12.png": "b02059c1cf66152286898c0220e4bbcf",
"assets/asset/logo/1080Background.png": "c508d9e14c1b398ff8a935c137a02d00",
"assets/asset/logo/favicon.png": "7c3614c14aa04d159da98f68648f0115",
"assets/asset/logo/512Transparent.png": "efb7d0165d02bd27484646dbbb73aef8",
"assets/asset/logo/logo.png": "544704f292e0b4cb9914027e748dada1",
"assets/asset/logo/app-icon.png": "96fe50484dc43fba4ddf475debeb9a6e",
"assets/asset/logo/splash-screen.png": "e7c298b2edeb29617ef93ef6ddd28ac1",
"assets/asset/logo/branding-android.png": "5da25e6b52afbcedf328f3619516c9f8",
"assets/AssetManifest.json": "2503e9d8685329d85116250dbbb38c58",
"assets/NOTICES": "d465934c1417816913a03403a1a4659f",
"assets/FontManifest.json": "6652b5cdb32c2b35c02c1f3450a17aef",
"assets/AssetManifest.bin.json": "beebb1d0024987f13e289683c8bb2bc6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "8cf82a439c51f774496949d6633e728f",
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
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-Medium.ttf": "b2e26657bde91d3d3f4dbc4d7010197e",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-ExtraBold.ttf": "e1e49dc3541972f5b7c26df8a5ae5d9a",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-VariableFont_wght.ttf": "74e0325138e01274149c3edf123360c5",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-Black.ttf": "76fd2f6ac13db0b5f3e173717c765b85",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-ExtraLight.ttf": "61843bae8d85e850a2b9e39fdf29dc7f",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-Regular.ttf": "a81ff45ebf2f1aa10df144b7a407926a",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-Light.ttf": "c71b849419d6561a570a89eb8debce8c",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-Thin.ttf": "d9ae2037448184a8927bd7d8748a53b2",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-SemiBold.ttf": "f1f514ca0d30100d42e8414b84eac0be",
"assets/packages/smart/fonts/LeagueSpartan/LeagueSpartan-Bold.ttf": "9a223d8a028354713a4a4072dc19250a",
"assets/packages/smart/fonts/Nunito/Nunito-Medium.ttf": "d26cecc95cdc8327b337357e6c5c1f5b",
"assets/packages/smart/fonts/Nunito/Nunito-ExtraBoldItalic.ttf": "e01118312e526f062fc8ad8f3c64de0e",
"assets/packages/smart/fonts/Nunito/Nunito-ExtraBold.ttf": "5b5a206f5cd32fa496c93925d0caf609",
"assets/packages/smart/fonts/Nunito/Nunito-ExtraLightItalic.ttf": "f9088a8e7dae2fc4e88975f6e1726c93",
"assets/packages/smart/fonts/Nunito/Nunito-VariableFont_wght.ttf": "ea0ad4c72a135f9a43ec7bb83f2469aa",
"assets/packages/smart/fonts/Nunito/Nunito-Light.ttf": "7de99c591b88e33ceda578f9ee140263",
"assets/packages/smart/fonts/Nunito/Nunito-Regular.ttf": "b83ce9c59c73ade26bb7871143fd76bb",
"assets/packages/smart/fonts/Nunito/Nunito-SemiBold.ttf": "38257ec36f55676f98fcdf1264adb69d",
"assets/packages/smart/fonts/Nunito/Nunito-Bold.ttf": "ba43cdecf9625c0dcec567ba29555e15",
"assets/packages/smart/fonts/Nunito/Nunito-BoldItalic.ttf": "dc69781f4856bdb711087d1ae07ca208",
"assets/packages/smart/fonts/Nunito/Nunito-Black.ttf": "27ee28fd596c0bd4235fa792d0d8b1ce",
"assets/packages/smart/fonts/Nunito/Nunito-ExtraLight.ttf": "ef7ff1b92707646c2e02a39067aab385",
"assets/packages/smart/fonts/Nunito/Nunito-SemiBoldItalic.ttf": "4c2772c15392fbfdb077342b7851f66c",
"assets/packages/smart/fonts/Nunito/Nunito-BlackItalic.ttf": "47e66b00cd98f1925da80dd6b7ff29a1",
"assets/packages/smart/fonts/Nunito/Nunito-Italic-VariableFont_wght.ttf": "14e83abff83f855acdf3bfd30da3ad79",
"assets/packages/smart/fonts/Nunito/Nunito-Italic.ttf": "fac5c8ffb51e06094affdbb7fff9000e",
"assets/packages/smart/fonts/Nunito/Nunito-LightItalic.ttf": "cdf25a6c9cbb6def64afcc30d3e511b9",
"assets/packages/smart/fonts/Nunito/Nunito-MediumItalic.ttf": "bd282ec988480f875b2f7cb0465ff7fa",
"assets/packages/smart/fonts/Glow/Glow.ttf": "e0ed2b5c6efde788febc216e5ee69fc2",
"assets/packages/smart/assets/anim/wallet.png": "381ed1cffb2410910376bef3c0925d5f",
"assets/packages/smart/assets/anim/review.png": "6cfc22ea0d3bf5d67224c312d310b232",
"assets/packages/smart/assets/anim/verified.png": "ffb8bf972443da7a132601aa05ab1ec9",
"assets/packages/smart/assets/anim/notes.png": "5eb9b3eae77b1821956546d808ced18d",
"assets/packages/smart/assets/anim/darkWallpaper.png": "091f3f980db7e416b3591c1a6e756cbb",
"assets/packages/smart/assets/anim/lightWallpaper.png": "438b52de3200edd30bd83aefe34e982b",
"assets/packages/smart/assets/anim/messages.png": "d45b92b88f2886e7818598cfa18ad6c1",
"assets/packages/smart/assets/anim/serch_chat.png": "42a45cd846466007de246ae35665558d",
"assets/packages/smart/assets/app/user.png": "198f4d4fcc319e7ab94a7d1df8b6f2f1",
"assets/packages/smart/assets/app/business.png": "ce352d15f6a433d55c24d9e9b685ba05",
"assets/packages/smart/assets/app/provider.png": "e8955eb4aaf3fb60970e4857e628cafb",
"assets/packages/smart/assets/app/nearby.png": "96fe50484dc43fba4ddf475debeb9a6e",
"assets/packages/smart/assets/social_styled/instagram.png": "ae78a71349b68cdec8178362dcced4b4",
"assets/packages/smart/assets/social_styled/twitter.png": "6582c5b6c68c15e9619746582fb4129a",
"assets/packages/smart/assets/social_styled/whatsapp.png": "93eceab7764f20c2b7d220d9d7c0af19",
"assets/packages/smart/assets/social_styled/facebook.png": "de3dc7aec21d0c84d048526feb5328bc",
"assets/packages/smart/assets/social_styled/snapchat.png": "3965ca1f5dbd773fa88f79fd610e7c7b",
"assets/packages/smart/assets/social/instagram.png": "c330afdb8618ef32c1d0316618b568f6",
"assets/packages/smart/assets/social/tiktok.png": "6db40a8dc02dffb694e33088affa2d44",
"assets/packages/smart/assets/social/asterisk.png": "1850df7a2ef373906e80e60bad78ad50",
"assets/packages/smart/assets/social/twitter.png": "0dbaeb77f81526ee33db60a21f43395d",
"assets/packages/smart/assets/social/linkedin.png": "077d90d74c8c2f41ae7837bc276f8ffb",
"assets/packages/smart/assets/social/youtube.png": "2928f76b90a345767da17f31f5ec7ddb",
"assets/packages/smart/assets/social/whatsapp.png": "df117803389876cd6de320a53bae792b",
"assets/packages/smart/assets/common/sharedLink.png": "7d55df8877c998d9e9eb79ad31e2b5e5",
"assets/packages/smart/assets/common/speak.png": "356ad0246b4811953dca4bd1f894f6d5",
"assets/packages/smart/assets/common/referralProgram.png": "3129c2831cc540855ad57e2fe7de6631",
"assets/packages/smart/assets/common/shop.png": "0a92c5d0b1244834828a4fbaea07b9dc",
"assets/packages/smart/assets/common/account.png": "785960c96043c736b940d5566f502dea",
"assets/packages/smart/assets/common/skill.png": "88292680a39d28dbb95b1cd2b47d1533",
"assets/packages/smart/assets/common/connect.png": "d90dbb6abf96a7723db4e97efe64a764",
"assets/packages/smart/assets/common/bookmark.png": "bde0e1492dedc8cb7a48e16f3c408ada",
"assets/packages/smart/assets/common/onboard2.png": "5e32dbb17bd2203f64701b780f019fd3",
"assets/packages/smart/assets/common/drive.png": "33a1e114b6d31190c1fe1e0ad00af01d",
"assets/packages/smart/assets/common/share.png": "c8109b9bb939c80ac8253f97e1d2f7e4",
"assets/packages/smart/assets/common/notLaunched.png": "785397012a43b10b3caaf5b07747835d",
"assets/packages/smart/assets/common/onboard1.png": "54c47c44229b94514aba5f921681f11d",
"assets/packages/smart/assets/common/organization.png": "9074740d002e3ee00771f18217c947cb",
"assets/packages/smart/assets/common/personal.png": "5f72d30026f2705f61cb8809867e83da",
"assets/packages/smart/assets/common/gender.png": "b18b5fc52368a3d1881682d674bc379c",
"assets/packages/smart/assets/common/account_trust.png": "eb1f098acbc12669d48527a45887e249",
"assets/packages/smart/assets/map/world.png": "cc972b14e76da37a89aa682ec523579c",
"assets/packages/smart/assets/map/fly.png": "087023dc77d6cf6b1ac2abfe5c25152f",
"assets/packages/smart/assets/map/upRight.png": "442fbd8120ae812a2a15f9d0dcac7afa",
"assets/packages/smart/assets/map/openStreetMap.png": "ed886fab8c104191559683c7753f1292",
"assets/packages/smart/assets/map/destination.png": "78d9c6137934e6d2e742ac24c6b68b2e",
"assets/packages/smart/assets/map/googleMap.png": "30f0baf2a9e5ee0251fe7d7026e74ceb",
"assets/packages/smart/assets/map/mapRight.png": "55f53a18e6f097a64cf9fff2329e37c5",
"assets/packages/smart/assets/map/drive.png": "8d0088dcfdb6f048bf4c143732147d0b",
"assets/packages/smart/assets/map/location.png": "3bb67badf1820534c9763b8c7fc129d0",
"assets/packages/smart/assets/map/current.png": "a58ef16baba47475efeb68c1815e12a1",
"assets/packages/smart/assets/map/bing.png": "ea9bdeeae4e415fe5f3e28f4186991cf",
"assets/packages/smart/assets/theme/dark.png": "c4d0bd15571a42340352bb4cb8cd0308",
"assets/packages/smart/assets/theme/light.png": "9013d43b9f141c3bf3b6e3a4ecac5a88",
"assets/packages/smart/assets/drive/driveWhiteReverse.png": "ba6a7967d89a0929f751592558c5041c",
"assets/packages/smart/assets/drive/driveBlackReverse.png": "548957505304f0dbd05ee4a4222de7b0",
"assets/packages/smart/assets/drive/driveTo.png": "7fd268826d846a151d67b3b3eff7b7c6",
"assets/packages/smart/assets/drive/driveCarBlackReverse.png": "e8103b8149b7fdb3fbf858caa4fd7cc3",
"assets/packages/smart/assets/drive/driveCarWhiteReverse.png": "056d1665554167ecacdb9c210bbf55bf",
"assets/packages/smart/assets/drive/driveBlack.png": "100d66fb51969229c867d25cc30522d7",
"assets/packages/smart/assets/drive/driveCarBlack.png": "e265e0382d8ce8528e52724501eff77c",
"assets/packages/smart/assets/drive/driveWhite.png": "e61bea6b7c46b802c12fc62b533a1a60",
"assets/packages/smart/assets/drive/driveCarWhite.png": "9df6f3b66cfbbd1c525e226a185a2930",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/multimedia/images/grey.bmp": "3c1df92d469b25a207c3d1af665aafd8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "75ef860819b504fe5472eb556aad33fb",
"assets/fonts/MaterialIcons-Regular.otf": "493654e609ad318c3773f0cdd1ef35b2",
"favicon-32x32.png": "d0d05f28f18fa6df6cc02f3609d9ee2e",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
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
