using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using MSTEFramework;

namespace MSTEDemo {
    class Person : MSTEInterface {

        protected string firstName { get; set; }
        protected Person mariedTo { get; set; }
        protected string name { get; set; }
        protected DateTime birthday { get; set; }
        protected Person mother { get; set; }
        protected Person father { get; set; }

        protected bool? aBool { get; set; }
        protected int? aInt { get; set; }
        protected MSNumber aNumber1 { get; set; }
        protected MSNumber aNumber2 { get; set; }
        protected MSNumber aNumber3 { get; set; }


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
            res += System.Environment.NewLine + " aBool : " + (this.aBool != null ? ((bool)this.aBool ? "TRUE" : "FALSE") : "-");
            res += System.Environment.NewLine + " aInt : " + (this.aInt != null ? ((int)this.aInt).ToString() : "-");
            res += System.Environment.NewLine + " aNumber1 : " + (this.aNumber1 != null ? this.aNumber1.ToString() : "-");
            res += System.Environment.NewLine + " aNumber2 : " + (this.aNumber2 != null ? this.aNumber2.ToString() : "-");
            res += System.Environment.NewLine + " aNumber3 : " + (this.aNumber3 != null ? this.aNumber3.ToString() : "-");

            res += System.Environment.NewLine + "---------------- ";
            return res;
        }


        #region MSTEInterface Membres

        public void initWithDictionary(Dictionary<string, object> dict) { //<string, object> dict) {           
            try {

                this.firstName = dict.ContainsKey("firstName") ? (string)dict["firstName"] : "";
                this.mariedTo = dict.ContainsKey("maried-to") ? (Person)dict["maried-to"] : null;
                this.name = dict.ContainsKey("name") ? (string)dict["name"] : "";
                this.birthday = dict.ContainsKey("birthday") ? (DateTime)dict["birthday"] : DateTime.MinValue;
                this.mother = dict.ContainsKey("mother") ? (Person)dict["mother"] : null;
                this.father = dict.ContainsKey("father") ? (Person)dict["father"] : null;

                this.aBool = dict.ContainsKey("aBool") ? (bool?)dict["aBool"] : null;
                this.aInt = dict.ContainsKey("aInt") ? (int?)dict["aInt"] : null;
                this.aNumber1 = dict.ContainsKey("aNumber1") ? (MSNumber)dict["aNumber1"] : null;
                this.aNumber2 = dict.ContainsKey("aNumber2") ? (MSNumber)dict["aNumber2"] : null;
                this.aNumber3 = dict.ContainsKey("aNumber3") ? (MSNumber)dict["aNumber3"] : null;
            }
            catch (Exception e){
                Console.WriteLine(e.Message);
            }
        }

        public Dictionary<string, object> Snapshot() {
            Dictionary<string, object> dict = new Dictionary<string, object>();

            if (this.firstName != "") dict["firstName"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.firstName, true);
            if (this.mariedTo != null) dict["maried-to"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.mariedTo, true);
            if (this.name != "") dict["name"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.name, true);
            if (this.birthday != null) dict["birthday"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.birthday, true);
            if (this.father != null) dict["father"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.father, true);
            if (this.mother != null) dict["mother"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.mother, true);
            //
            if (this.aBool != null) dict["aBool"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.aBool);
            if (this.aInt != null) dict["aInt"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.aInt);
            if (this.aNumber1 != null) dict["aNumber1"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.aNumber1, true);
            if (this.aNumber2 != null) dict["aNumber2"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.aNumber2, true);
            if (this.aNumber3 != null) dict["aNumber3"] = MSTE.CREATE_MSTE_SNAPSHOT_VALUE(this.aNumber3, true);

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

    class Person2 : Person {

        public override string ToString() {
            string res = "";
            res += System.Environment.NewLine + "---------------- ";
            res += System.Environment.NewLine + "Personne 2 : ";
            res += System.Environment.NewLine + "---------------- ";
            res += System.Environment.NewLine + " name : " + name;
            res += System.Environment.NewLine + " firstName : " + this.firstName;
            res += System.Environment.NewLine + " birthday : " + (this.birthday.CompareTo(DateTime.MinValue) != 0 ? this.birthday.ToShortDateString() : "");
            res += System.Environment.NewLine + "---------------- ";
            res += System.Environment.NewLine + " aBool : " + (this.aBool != null ? ((bool)this.aBool ? "TRUE" : "FALSE") : "-");
            res += System.Environment.NewLine + " aInt : " + (this.aInt.ToString());
            res += System.Environment.NewLine + " aNumber1 : " + (this.aNumber1 != null ? this.aNumber1.ToString() : "-");
            res += System.Environment.NewLine + " aNumber2 : " + (this.aNumber2 != null ? this.aNumber2.ToString() : "-");
            res += System.Environment.NewLine + " aNumber3 : " + (this.aNumber3 != null ? this.aNumber3.ToString() : "-");
            res += System.Environment.NewLine + "---------------- ";
            return res;
        }
    }

}