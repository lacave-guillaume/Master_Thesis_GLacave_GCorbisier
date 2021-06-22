/*
   Code réalisé le 16/05/2021 par Gauthier Corbisier avec l'aide du code de Laurent Remy et Olivier de Vinck.
   Le but de ce code est d'obtenir suffisament d'informations via la prise OBD d'un véhicule diesel pour obtenir
   le débit massique entrant et sortant du véhicule. Toutes ces onformations sont ensuite enregistrées sur
   une carte micro SD. Ce programme est dédié à un Arduino Mega. Les données obtenues vont apparaitre sous la
   forme : "ENGINE_TEMP: 1 05 7C", le 05 correspondant au OBD-II PID, le 7C correspondant à la valeur renvoyée 
   en hexadécimal. Plus d'informations https://en.wikipedia.org/wiki/OBD-II_PIDs
*/

#include <Wire.h>
#include <SoftwareSerial.h>
#include <ELM327.h> //Librairie pour le lecteur OBD2 

// Déclaration ELM327
#define ELM_TIMEOUT 9000
#define ELM_BAUD_RATE 9600
#define ELM_PORT Serial1
Elm327 Elm;

// Initialisation du buffer
char rxData[20];
char rxIndex = 0;
// On regarde quels PID sont rendus disponibles par la voiture
static const char cmds[][6] = {"0100\r","0120\r", "0140\r","0160\r","0180\r"};
const int nbr_cmds = 5;
char cmdnames[][30] = {"PID_20","PID_40","PID_60","PID_80","PID_100"};
char buf[128];


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


    for (byte i = 1; i < rxIndex ; i++) {
      Serial.print(rxData[i]); // On affiche les bytes recus
    }
    rxData[rxIndex++] = '\0'; // On convertit le byte en string
    rxIndex = 0; // On remet a 0 pour ’nettoyer’ le
    // buffer
    Serial1.flush();
  
}


///////////////////////////
///////////SETUP///////////
///////////////////////////

void setup() {
  Serial.begin(115200);
  Serial1.begin(9600);
  Serial.println("Début du setup");
  delay(1000);
  
  //OBD
  OBD_init();
  delay(1000);
  Serial.println("OBD initialized");


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

  delay(5000); // Attendre 0,1 s entre chaque iteration de la boucle
}
