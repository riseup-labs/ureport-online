import 'package:flutter/material.dart';
import 'package:ureport_ecaro/all-screens/home/articles/shared/top_header_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopHeaderWidget(title: "Despre"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Despre proiect",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "U-Report este un mecanism de consultare dezvoltat de UNICEF prin care copiii și tinerii sunt încurajați să vorbească despre lucrurile care contează cu adevărat pentru ei.\n\nÎn acest moment sunt peste 6 milioane de U-reporteri în 50 de țări din întreaga lume, iar comunitatea este în continuă creștere. Intră pe pagina globală U-Report aici: https://www.ureport.in/. U-Report este o platformă de consultare inspirată de Convenția Națiunilor Unite privind drepturile copilului, care își propune să promoveze drepturilor tuturor copiilor și adolescenților de a își exprima liber opinia asupra oricărei probleme care îi privește (articolul 12), libertatea de exprimare (articolul 13), dreptul de întrunire și asociere cu alte persoane (articolul 15) și dreptul de a avea acces la informații (articolul 17).      \n\nU-Report este folosit pentru a afla care sunt provocările cu care se confruntă copiii și adolescenții, dar și problemele comunităților în care ei trăiesc, pentru a găsi soluții la acestea.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  "https://i.imgur.com/W6vIfqE.png",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Cum funcționează U-Report?\n\nU-Report se bazează pe membrii înscriși voluntar ca U-Reporteri. Platforma de consultare are la bază sistemul RapidPro, un sistem de mesaje directe, în care utilizatorii fac primul pas în interacțiunea cu U-Report. Sistemul nu va trimite mesaje către cei care nu își doresc să se înscrie și să facă parte din comunitatea U-Report.\n\nDupă înregistrare, mesajele și sondajele U-Report sunt trimise prin mesaje directe, prin Facebook Messenger. Informațiile despre U-Reporteri sunt anonime. Răspunsurile obținute sunt vizibile în timp real pe acest site. Rezultatele sunt grupate după vârstă, gen și regiune și sunt utilizate pentru a crește gradul de conștientizare a cetățenilor cu privire la copiilor și tinerilor, problemele și soluțiile propuse de aceștia. \n\nÎn același timp, U-Reporterii primesc mesaje și informații despre importanța participării lor, află care sunt rezultatele sondajelor, modul în care informațiile au fost folosite, felul în care vocile lor au ajuns la factorii de decizie și care au fost rezultatele contribuției lor.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "De ce sa devin U-REPORTER ? ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "1. Îți vei face auzită părerea despre subiecte și probleme care te preocupă. \n2. Rezultatele sondajelor U-Report contribuie la identificarea provocărilor și a problemelor cu care se confruntă copiii, tinerii și comunitățile lor, dar și a soluțiilor propuse de voi.\n3. Vei participa la sondaje naționale și vei face parte din marea familie globală de U-Reporteri! \n\n\nDacă te confrunți cu dificultăți tehnice sau ai orice alte întrebări legate de U-Report, te rugăm să ne contactezi pe email la: ureport@unicef.ro",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
