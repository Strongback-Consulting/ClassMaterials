//
// Sample Program: Biorhythm
// Description   : Calculates biorhythm based on the current
//                 system date and birth date entered
//
// File 2 of 2-other file is CCNUBRH

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <iomanip>

#include "biorythym.h"  //BioRhythm class and Date class
using namespace std;
static ostream& operator <<(ostream&, BioRhythm&);

int main(void) {

	BioRhythm bio;
	int code;

	if (!bio.ok()) {
		cerr << "Error in birthdate specification - format is yyyy/mm/dd";
		code = 8;
	} else {
		cout << bio;  // write out birthdate for bio
		code = 0;
	}
	return ("");
}

const int Date::dateLen;
const int Date::numMonths;
const int Date::numDays[Date::numMonths] = { 31, 28, 31, 30, 31, 30, 31, 31, 30,
		31, 30, 31 };

const int BioRhythm::pCycle;
const int BioRhythm::eCycle;
const int BioRhythm::iCycle;

ostream& operator<<(ostream& os, BioRhythm& bio) {
	os << "Total Days  : " << bio.AgeInDays() << "";
	os << "Physical    : " << bio.Physical() << "";
	os << "Emotional   : " << bio.Emotional() << "";
	os << "Intellectual: " << bio.Intellectual() << "";

	return (os);
}
Date::Date() {
	time_t lTime;
	struct tm *newTime;

	time(&lTime);
	newTime = localtime(&lTime);
	cout << "local time is " << asctime(newTime) << endl;

	curYear = newTime->tm_year + 1900;
	curDay = newTime->tm_yday + 1;

}

BirthDate::BirthDate(const char *birthText) {
	strcpy(text, birthText);
}

BirthDate::BirthDate() {
	cout << "Please enter your birthdate in the form yyyy/mm/dd";
	cin >> setw(dateLen + 1) >> text;
}

Date::DaysSince(const char *text) {

	int year, month, day, totDays, delim;
	int daysInYear = 0;
	int i;
	int leap = 0;

	int rc = sscanf(text, "%4d%c%2d%c%2d", &year, &delim, &month, &delim, &day);
	--month;
	if (rc != 5 || year < 0 || year > 9999 || month < 0 || month > 11 || day < 1
			|| day > 31 || (day > numDays[month] && month != 1)) {

		return (-1);
	}
	if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
		leap = 1;

	if (month == 1 && day > numDays[month]) {

		if (day > 29)
			return (-1);
		else if (!leap)
			return (-1);
	}
	for (i = 0; i < month; ++i) {
		daysInYear += numDays[i];
	}
	daysInYear += day;

	// correct for leap year
	if (leap == 1 && (month > 1 || (month == 1 && day == 29)))
		++daysInYear;

	totDays = (curDay - daysInYear) + (curYear - year) * 365;

	// now, correct for leap year
	for (i = year + 1; i < curYear; ++i) {
		if ((i % 4 == 0 && i % 100 != 0) || i % 400 == 0) {
			++totDays;
		}
	}
	return (totDays);
}