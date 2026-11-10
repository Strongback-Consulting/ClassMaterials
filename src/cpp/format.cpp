/*
 * format.c
 *
 *  Created on: Apr 23, 2013
 *      Author: Kenny Smith
 *              Strongback Consulting
 */

#include <stdio.h>
#include "biorythm.h"


struct patient
    {
char deceased;
char name[41];
int age;
float height;
char bloodtype[3];
struct birthdate{int month;int day; int year;} ;
} ;

int main(int argc,char **argv) {
    int byear = 1;

printf("What is your patient's year of birth?: \n");
scanf("%d", &byear);
struct patient p1;
p1.deceased = 1;

}

class Address{
public:
Address(char *street){
}
void setAddress(char *street, char *city,
	char *state, char *zip){
street = *street;
}
private:
char street[40];
    char city[15];
 int zip;
  char state[2];
}










