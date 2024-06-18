FROM maven:3.9-eclipse-temurin-11

ARG CHROME_VERSION=126.0.6478.61-1
RUN apt-get update -qqy \
        && apt-get -qqy install gpg unzip \
        && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
        && apt-get update -qqy \
        && apt-get -qqy install google-chrome-stable=$CHROME_VERSION \
        && rm /etc/apt/sources.list.d/google-chrome.list \
        && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
        && sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

COPY pom.xml .
RUN mvn --batch-mode --no-transfer-progress dependency:resolve
