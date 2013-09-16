using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using MSTE;

namespace MSTE {
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

        public Person(string n, string fn, DateTime bd, Person mt, Person m, Person f)
            : this(n, fn, bd) {
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
            //res += "\nbirthday : " + (this.birthday.CompareTo(DateTime.MinValue) == 0 ? this.birthday.ToShortDateString() : "");
            res += System.Environment.NewLine + " maried-to : " + (this.mariedTo != null ? this.mariedTo.firstName.ToString() : "-");
            res += System.Environment.NewLine + " mother : " + (this.mother != null ? this.mother.firstName.ToString() : "-");
            res += System.Environment.NewLine + " father : " + (this.father != null ? this.father.firstName.ToString() : "-");
            res += System.Environment.NewLine + "---------------- ";
            res += System.Environment.NewLine;
            return res;
        }


        #region MSTEInterface Membres

        //// From interface
        //public object newObject() {
        //    return (object)new Person("", "", DateTime.MinValue);
        //}

        public void initWithDictionary(Dictionary<string, object> dict) { //<string, object> dict) {
            string n = dict.ContainsKey("name") ? (string)dict["name"] : "";
            string fn = dict.ContainsKey("firstName") ? (string)dict["firstName"] : "";
            //DateTime bd = dict.ContainsKey("birthday") ? (DateTime)dict["birthday"] : null;
            Person mt = dict.ContainsKey("maried-to") ? (Person)dict["maried-to"] : null;
            Person m = dict.ContainsKey("mother") ? (Person)dict["mother"] : null;
            Person f = dict.ContainsKey("father") ? (Person)dict["father"] : null;
            this.name = n;
            this.firstName = fn;
            this.birthday = DateTime.MinValue;
            this.mariedTo = mt;
            this.mother = m;
            this.father = f;
        }

        public Hashtable Snapshot() {
            return null;
            //$dict = new MSDict();
            //$dict->setValueForKey('name', 'name');
            //$dict->setValueForKey('firstName', 'firstName');
            //$dict->setValueForKey('birthday', 'birthday');
            //$dict->setValueForKey('maried-to', 'mariedTo');
            //$dict->setValueForKey('mother', 'mother');
            //$dict->setValueForKey('father', 'father');
            //return  $dict;
        }

        #endregion

    }
}