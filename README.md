<h1 align="center">StormBreaker CI</h1>

<p align="center">
   <a href="https://dl.circleci.com/status-badge/redirect/gh/StormBreaker-Infrastructure/stormCI/tree/master"><img src="https://dl.circleci.com/status-badge/img/gh/StormBreaker-Infrastructure/stormCI/tree/master.svg?style=svg"></a><br>
   <a href="https://opensource.org/licenses/Apache-2.0"><img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-blue.svg"/></a>
</p>

For documentation on how to run a build, see
<a alt="Usage" href="Documentation/Usage.txt">Usage.txt</a><br>

### Deploying and running our container
To create and run our container, we can use the following command syntax:

```
docker-compose -f "docker-compose.yml" up -d --build
docker-compose exec build-kernel bash
```

# License
```xml
Copyright 2019 danascape (Saalim Quadri)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
