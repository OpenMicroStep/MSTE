package org.openmicrostep.mste;

import java.util.Date;

//------ Date Class with GMT0 ---------------------
public class MSDate extends java.util.Date {
	
	public MSDate(){
		super();
	}	

	public MSDate(int year, int month, int date) throws MSTEException {
		throw new MSTEException("Constructor MSDate(int year, int month, int date) Deprecated");
	}

	public MSDate(int year, int month, int date, int hrs, int min) throws MSTEException {
		throw new MSTEException("Constructor MSDate(int year, int month, int date, int hrs, int min) Deprecated");
	}

	public MSDate(int year, int month, int date, int hrs, int min, int sec)	throws MSTEException {
		throw new MSTEException("Constructor MSDate(int year, int month, int date, int hrs, int min) Deprecated");
	}

	public MSDate(long date) {
		super(date);		
	}

	public MSDate(String s) throws MSTEException {
		throw new MSTEException("Constructor MSDate(String s) Deprecated");
	}

	public boolean after(MSDate when){
		return super.after(when);
	}

	public boolean before(MSDate when){
		return super.before(when);
	}

	public Object clone(){
		return super.clone();
	}

	public int compareTo(MSDate anotherDate){
		return super.compareTo(anotherDate);
	}

	public boolean equals(Object obj){
		return super.equals(obj);
	}

	public int getDate() {
		System.out.println("Method getDate() Deprecated");
		return -1;
	}

	public int getDay() {
		System.out.println("Method getDay() Deprecated");
		return -1;
	}

	public int getHours() {
		System.out.println("Method getHours() Deprecated");
		return -1;
	}

	public int getMinutes() {
		System.out.println("Method getMinutes() Deprecated");
		return -1;
	}

	public int getMonth() {
		System.out.println("Method getMonth() Deprecated");
		return -1;
	}

	public int getSeconds() {
		System.out.println("Method getSeconds() Deprecated");
		return -1;
	}

	public long getTime() {
		return super.getTime();
	}

	public int getTimezoneOffset() {
		System.out.println("Method getTimezoneOffset() Deprecated");
		return -1;
	}

	public int getYear() {
		System.out.println("Method getYear() Deprecated");
		return -1;
	}

	public int hashCode() {
		return super.hashCode();
	}

	public static long parse(String s) {
		System.out.println("Method parse(String s) Deprecated");
		return -1;
	}

	public void setDate(int date) {
		System.out.println("Method setDate(int date) Deprecated");
	}

	public void setHours(int hours) {
		System.out.println("Method setHours(int hours) Deprecated");
	}

	public void setMinutes(int hours) {
		System.out.println("Method setMinutes(int hours) Deprecated");
	}

	public void setMonth(int month) {
		System.out.println("Method setMonth(int month) Deprecated");
	}

	public void setSeconds(int seconds) {
		System.out.println("Method setSeconds(int seconds) Deprecated");
	}

	public void setTime(long time) {
		super.setTime(time);
	}

	public void setYear(int year) {
		System.out.println("Method setYear(int year) Deprecated");
	}

	public String toGMTString() {
		System.out.println("Method toGMTString() Deprecated");
		return "";
	}

	public String toLocaleString() {
		System.out.println("Method toLocaleString() Deprecated");
		return "";
	}

	public String toString() {
		return super.toString();
	}

	public static long UTC(int year, int month, int date, int hrs, int min, int sec) {
		System.out.println("Method toLocaleString() Deprecated");
		return -1;
	}
	
}