# 🌐 Serchservice Drive Web Application

Welcome to the **Serchservice Drive Web Application**! This web-based solution is designed to complement the mobile experience, allowing users to seamlessly search for nearby services and connect with them efficiently.

## 🚀 Project Overview

The web application brings the power of the **Serchservice Drive** platform to desktop and mobile browsers. It simplifies the "nearby search" experience using our intuitive category connectors and integrations.

The project is built using modern web technologies, with a primary focus on **Flutter Web** for a responsive and performant user experience.

## 📦 Dependencies & Packages

This project relies on several Flutter and web packages to deliver a feature-rich experience. Below are some key dependencies:

- [`flutter`](https://flutter.dev/)
- [`get`](https://pub.dev/packages/get)
- [`firebase_core`](https://pub.dev/packages/firebase_core)
- [`connectify_flutter`](https://github.com/Serchservice/connectify_flutter) (Custom Serchservice package)

### Special Configuration for `connectify_flutter`

To access the `connectify_flutter` package, you need to set up authentication via a `.netrc` file. This file allows secure access to the private package hosted on GitHub.

Create a `.netrc` file in your home directory with the following content:

```bash
machine github.com
login your_username
password your_personal_access_token
```

Replace `your_username` and `your_personal_access_token` with your actual GitHub credentials and personal access token.

For more information on GitHub authentication tokens, refer to [GitHub Docs](https://docs.github.com/en/rest).

## 🌟 Features

- **Responsive Design**: Optimized for desktop, tablet, and mobile browsers.
- **Service Search**: Seamlessly search for nearby services based on location.
- **Category Connectors**: Intuitive navigation and categorization for quick access.
- **Real-Time Updates**: Instant updates using Firebase integrations.

## 🚧 Development Setup

To set up the project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/Serchservice/nearby_webapp.git
   ```
2. Navigate to the project directory:
   ```bash
   cd nearby_webapp
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Set up your `.netrc` file as described above.
5. Run the application in web mode:
   ```bash
   flutter run -d chrome
   ```

## Deploying to Server
Before deploying to server, add this:

```html
<script>
   window.addEventListener('load', function(ev) {
       // Download main.dart.js
        _flutter.loader.load({
           entrypointUrl: "/main.dart.js",
           serviceWorker: {
               serviceWorkerVersion: {{flutter_service_worker_version}},
               serviceWorkerUrl: "/flutter_service_worker.js?v=",
           },
           onEntrypointLoaded: async function(engineInitializer) {
               // Initialize the Flutter engine
               let appRunner = await engineInitializer.initializeEngine({useColorEmoji: true,});
               // Run the app
               await appRunner.runApp();
           }
       });
   });
</script>
```

For firebase messaging, add this:
```html
<html>
<body>
  <script>
      var serviceWorkerVersion = null;
      var scriptLoaded = false;
      function loadMainDartJs() {
        if (scriptLoaded) {
          return;
        }
        scriptLoaded = true;
        var scriptTag = document.createElement('script');
        scriptTag.src = 'main.dart.js';
        scriptTag.type = 'application/javascript';
        document.body.append(scriptTag);
      }

      if ('serviceWorker' in navigator) {
        // Service workers are supported. Use them.
        window.addEventListener('load', function () {
          // Register Firebase Messaging service worker.
          navigator.serviceWorker.register('firebase-messaging-sw.js', {
            scope: '/firebase-cloud-messaging-push-scope',
          });

          // Wait for registration to finish before dropping the <script> tag.
          // Otherwise, the browser will load the script multiple times,
          // potentially different versions.
          var serviceWorkerUrl =
            'flutter_service_worker.js?v=' + serviceWorkerVersion;

          navigator.serviceWorker.register(serviceWorkerUrl).then((reg) => {
            function waitForActivation(serviceWorker) {
              serviceWorker.addEventListener('statechange', () => {
                if (serviceWorker.state == 'activated') {
                  console.log('Installed new service worker.');
                  loadMainDartJs();
                }
              });
            }
            if (!reg.active && (reg.installing || reg.waiting)) {
              // No active web worker and we have installed or are installing
              // one for the first time. Simply wait for it to activate.
              waitForActivation(reg.installing ?? reg.waiting);
            } else if (!reg.active.scriptURL.endsWith(serviceWorkerVersion)) {
              // When the app updates the serviceWorkerVersion changes, so we
              // need to ask the service worker to update.
              console.log('New service worker available.');
              reg.update();
              waitForActivation(reg.installing);
            } else {
              // Existing service worker is still good.
              console.log('Loading app from service worker.');
              loadMainDartJs();
            }
          });

          // If service worker doesn't succeed in a reasonable amount of time,
          // fallback to plaint <script> tag.
          setTimeout(() => {
            if (!scriptLoaded) {
              console.warn(
                'Failed to load app from service worker. Falling back to plain <script> tag.'
              );
              loadMainDartJs();
            }
          }, 4000);
        });
      } else {
        // Service workers not supported. Just drop the <script> tag.
        loadMainDartJs();
      }
  </script>
</body>
```

## 🛠️ CI/CD Pipeline

The web application is integrated with a CI/CD pipeline to automate the build and deployment process. The CI/CD setup ensures consistent versioning and a smooth deployment experience.

### Versioning

Make sure to **update the version** in the `pubspec.yaml` file for every release. The CI/CD pipeline uses this version for automated builds and deployment.

## 🤝 Contributing

We welcome contributions to the Serchservice Drive Web Application. To contribute, please fork the repository and submit a pull request with your changes. Ensure that your code follows best practices and includes relevant documentation.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Happy coding!** 🎉 If you encounter any issues, feel free to open an issue or reach out to the Serchservice team.