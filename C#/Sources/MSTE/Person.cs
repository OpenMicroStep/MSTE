using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using MSTEClasses;

namespace MSTEClasses {
    class Person : MSTEInterface {

        private string firstName { get; set; }
        private Person mariedTo { get; set; }
        private string name { get; set; }
        private DateTime birthday { get; set; }
        private Person mother { get; set; }
        private Person father { get; set; }

        public Person() {
        }

        public Person(string n, string fn, DateTime bd) {
            this.name = n;
            this.firstName = fn;
            this.birthday = bd;
        }

        public Person(string n, string fn, DateTime bd, Person mt, Person m, Person f) : this(n, fn, bd) {
            this.mariedTo = mt;
            this.mother = m;
            this.father = f;
        }

        public override string ToString() {
            string res = "";
            res += System.Environment.NewLine + "---------------- ";
            res += System.Environment.NewLine + "Personne : ";
            res += System.Environment.NewLine + "---------------- ";
            res += System.Environment.NewLine + " name : " + name;
            res += System.Environment.NewLine + " firstName : " + this.firstName;
            res += System.Environment.NewLine + " birthday : " + (this.birthday.CompareTo(DateTime.MinValue) != 0 ? this.birthday.ToShortDateString() : "");
            res += System.Environment.NewLine + " maried-to : " + (this.mariedTo != null ? this.mariedTo.firstName.ToString() : "-");
            res += System.Environment.NewLine + " mother : " + (this.mother != null ? this.mother.firstName.ToString() : "-");
            res += System.Environment.NewLine + " father : " + (this.father != null ? this.father.firstName.ToString() : "-");
            res += System.Environment.NewLine + "---------------- ";
            return res;
        }


        #region MSTEInterface Membres

        public void initWithDictionary(Dictionary<string, object> dict) { //<string, object> dict) {
            string fn = dict.ContainsKey("firstName") ? (string)dict["firstName"] : "";
            Person mt = dict.ContainsKey("maried-to") ? (Person)dict["maried-to"] : null;
            string n = dict.ContainsKey("name") ? (string)dict["name"] : "";
            DateTime bd = dict.ContainsKey("birthday") ? (DateTime)dict["birthday"] : DateTime.MinValue;
            Person m = dict.ContainsKey("mother") ? (Person)dict["mother"] : null;
            Person f = dict.ContainsKey("father") ? (Person)dict["father"] : null;
            
            this.firstName = fn;
            this.mariedTo = mt;
            this.name = n;
            this.birthday = bd;
            this.mother = m;
            this.father = f;
        }

        public Dictionary<string, object> Snapshot() {
            Dictionary<string, object> dict = new Dictionary<string, object>();

            MSCouple cp2 = new MSCouple();
            cp2.FirstMember = this.firstName;
            dict["firstName"] = cp2;

            if (this.mariedTo != null) {
                MSCouple cp4 = new MSCouple();
                cp4.FirstMember = this.mariedTo;
                dict["maried-to"] = cp4;
            }

            MSCouple cp1 = new MSCouple();
            cp1.FirstMember = this.name;
            dict["name"] = cp1;

            MSCouple cp3 = new MSCouple();
            cp3.FirstMember = this.birthday;
            dict["birthday"] = cp3;

            if (this.father != null) {
                MSCouple cp5 = new MSCouple();
                cp5.FirstMember = this.father;
                dict["father"] = cp5;
            }

            if (this.mother != null) {
                MSCouple cp6 = new MSCouple();
                cp6.FirstMember = this.mother;
                dict["mother"] = cp6;
            }

            return dict;

            //dict["name"] = "name";
            //dict["firstName"] = "firstName";
            //dict["birthday"] = "birthday";
            //dict["maried-to"] = "mariedTo";
            //dict["mother"] = "mother";
            //dict["father"] = "father";
            //return dict;
        }

        #endregion

    }
}