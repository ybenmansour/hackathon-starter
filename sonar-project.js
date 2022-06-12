const sonarqubeScanner =  require('sonarqube-scanner');
sonarqubeScanner(
    {
        serverUrl:  'http://localhost:9000',
        options : {
            'sonar.sources':  '.',
            'sonar.tests':  'src',
            'sonar.inclusions'  :  '**', // Entry point of your code
        }
    }, () => {});
