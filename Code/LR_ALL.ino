/*
   Code réalisé le 16/05/2021 par Gauthier Corbisier avec l'aide du code de Laurent Remy et Olivier de Vinck.
   Le but de ce code est d'obtenir suffisament d'informations via la prise OBD d'un véhicule diesel pour obtenir
   le débit massique entrant et sortant du véhicule. Toutes ces onformations sont ensuite enregistrées sur
   une carte micro SD. Ce programme est dédié à un Arduino Mega. Les données obtenues vont apparaitre sous la
   forme : "ENGINE_TEMP: 1 05 7C", le 05 correspondant au OBD-II PID, le 7C correspondant à la valeur renvoyée 
   en hexadécimal. Plus d'informations https://en.wikipedia.org/wiki/OBD-II_PIDs
*/
#include <SD.h> //Librairie pour carte SD pre-telechargee dans Arduino IDE
#include <Wire.h>
#include <ds3231.h> //Librairie pour le module DS3231
#include <SoftwareSerial.h>
#include <ELM327.h> //Librairie pour le lecteur OBD2 

// Déclaration ELM327
#define ELM_TIMEOUT 9000
#define ELM_BAUD_RATE 9600
#define ELM_PORT Serial1
Elm327 Elm;

// Initialisation du buffer
char rxData[30];
char rxIndex = 0;
// Commandes correspondant aux PIDs
// Les différentes adresses et leur interprétations se trouvent sur : https://en.wikipedia.org/wiki/OBD-II_PIDs
// Dans certains cas les données sont protégées par le constructeur et il n'est dès pas possible de les obtenir.
static const char cmds[][6] = {"0104\r","0105\r", "010B\r","010C\r","010D\r", "010E\r", "010F\r","0110\r", "0134\r", "0124\r", "012C\r", "012D\r","0146\r", "015D\r", "015E\r"};
const int nbr_cmds = 15;
char cmdnames[][30] = {"ENGINE_LOAD","ENGINE_TEMP","INTAKE_MAP","RPM","SPEED","TIMING_ADVANCE","INTAKE_TEMP","MAF_FLOW","OX_1_A", "OX_1_V", "COMMANDED_EGR","EGR_ERROR","AMBIANT_AIR","FUEL_INJECT_TIMING","FUEL_RATE"};
char buf[128];

// Declaration carte SD
const int spi_ssSD = 23; // declaration de la pin SD SS

// Structure déclarée et utilisée pour le module DS3231
struct ts t;

// Initialisation de la carte SD 
void Initialize_SDcard()
{
  digitalWrite(spi_ssSD, LOW); // debut de la communication avec la carte SD
  delay(1000);
  // On regarde si la carte SD est detectee
  if (!SD.begin(spi_ssSD)) {
    Serial.println("Card failed, or not present");
    return;
}

  // On ouvre le fichier.txt
  File dataFile = SD.open("LR_ALL.txt", FILE_WRITE);
  // Si il est disponible, on ecrit dessus.
  if (dataFile) {
    DS3231_get(&t);
    dataFile.println(" ");
    dataFile.print("TIME");
    dataFile.print(", ");

    // On rajoute les PIDs
    for (byte i = 0; i < nbr_cmds ; i++) 
    {
      dataFile.print(",");
      dataFile.print(cmdnames[i]);
    }
    dataFile.println();
    dataFile.close();
    digitalWrite(spi_ssSD, HIGH); // fin de la communication avec la carte SD
  }
}



// Initialisation de la prise OBD
void OBD_init(void)
{
  delay(2000); // Attendre 2 secondes avant de ’reset’ l’OBD
  Serial1.print("ATZ\r"); // ’Reset’ de l’OBD
  delay(2);
  OBD_read();
  Serial1.print("ATE0\r");
  OBD_read();
  Serial1.flush();
  Serial.print("OBD init ok");
}
// Fonction qui est appelée dans le loop permettant la lecture des informations de la prise OBD et l'écriture de
// ces dernières sur la carte SD dans un fichier texte. 
void OBD_read(void)
{
  File dataFile = SD.open("LR_ALL.txt", FILE_WRITE);
  if (dataFile) {

    char c;
    c = 0;
    rxData[0] = 0;

    do {

      if (Serial1.available() > 0)
      {
       
        c = Serial1.read();
        if ((c != '>') && (c != '\r') && (c != '\n')) // Retirer ces symboles du buffer
        {
          rxData[rxIndex++] = c; // On rajoute tout ce qu’on recoit du
          // buffer
        }
      }
    } while (c != '>'); // L’ELM327 annonce la fin de sa
    // reponse avec ce symbole


    for (byte i = 4; i < rxIndex ; i++) {
      dataFile.print(rxData[i]);
      Serial.print(rxData[i]); // On affiche les bytes recus
    }
    dataFile.print(",");
    rxData[rxIndex++] = '\0'; // On convertit le byte en string
    rxIndex = 0; // On remet a 0 pour ’nettoyer’ le
    // buffer
    Serial1.flush();
  }
  else
  {
    Serial.print("on n'arrive pas à écrire dans LR_ALL");
  }
  dataFile.close();
}


///////////////////////////
///////////SETUP///////////
///////////////////////////

void setup() {
  Serial.begin(115200);
  Serial1.begin(9600);
  Serial.println("Début du setup");
  delay(1000);
  

  //DS3231, changer les paramètres pour le mettre a la bonne date au moment du téléversement 
  Wire.begin();
  DS3231_init(DS3231_CONTROL_INTCN);
  t.hour = 0;
  t.min = 0;
  t.sec = 0;
  t.mday = 23;
  t.mon = 5;
  t.year = 2021;
  DS3231_set(t);

  //OBD
  OBD_init();
  delay(1000);
  Serial.println("OBD initialized");

  // SD
  Initialize_SDcard();
  delay(1000);
  pinMode(spi_ssSD, OUTPUT); // Definir la pin controle SD comme output
  delay(1000);
  digitalWrite(spi_ssSD, HIGH); // Pin controle SD circuit ouvert
  Serial.println("SD initialized");




  for (byte i = 0; i < nbr_cmds ; i++)
  {
    Serial.print(cmdnames[i]);
    if (i != nbr_cmds-1)
    {
      Serial.print(",");
    }
  }
  Serial.println();

  delay(2000); // Attendre 2 secondes que l’initialisation soit bien terminee
}

///////////////////////////
///////////LOOP////////////
///////////////////////////


void loop() {
  
  // SD
  digitalWrite(spi_ssSD, LOW); // debut de la communication avec la carte SD
  delay(200);

  // DS3231
  DS3231_get(&t);

  File dataFile = SD.open("LR_ALL.txt", FILE_WRITE);
  if (dataFile) {
    // On enregistre toutes les variables precedemment determinees
    dataFile.println(" ");
    dataFile.print(t.hour);
    dataFile.print(":");
    dataFile.print(t.min);
    dataFile.print(":");
    dataFile.print(t.sec);
    dataFile.print("\t");
    dataFile.print(", ");
    delay(100);
  }
  else
  {
    Serial.print("OUPS1");
  }
  dataFile.close();
  delay(100);

  // OBD
  for (byte i = 0; i < nbr_cmds ; i++) {

    Serial.print(cmdnames[i]);
    Serial.print(": ");
    //On supprime toutes donnees restantes dans le port serie
    while (Serial1.read() >= 0)
    {

    }
    Serial1.print(cmds[i]); // On affiche le nom de la commande

    OBD_read(); // On affiche le resultat de l’OBD
    if (i != nbr_cmds - 1)
    {
      Serial.print(",");
    }
  }
  Serial.println();


  dataFile = SD.open("LR_ALL.txt", FILE_WRITE);
  dataFile.println();
  dataFile.close();

  digitalWrite(spi_ssSD, HIGH); // fin de la communication avec la carte SD
  delay(250); // Attendre 0,1 s entre chaque iteration de la boucle
}
