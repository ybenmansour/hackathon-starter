const sonarqubeScanner =  require('sonarqube-scanner');
sonarqubeScanner(
    {
        serverUrl:  'http://sonar-server:9000',
        options : {
            'sonar.sources':  '.',
            'sonar.tests':  'src',
            'sonar.inclusions'  :  '**', // Entry point of your code
        }
    }, () => {});
