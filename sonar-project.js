var sonarqubeScanner = require('sonarqube-scanner').customScanner;
sonarqubeScanner(
    {
        serverUrl:  'http://localhost:9000',
        options : {
            'sonar.projectName': 'hackathon-starter',   
            'sonar.sources':  '.',
            'sonar.tests':  'src',
            'sonar.inclusions'  :  '**', 
        }
    }, () => {});
