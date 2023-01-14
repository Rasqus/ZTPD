import java.io.IOException;
import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.runtime.client.EPRuntime;
import com.espertech.esper.runtime.client.EPRuntimeProvider;
import com.espertech.esper.common.client.EPCompiled;
import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompileException;
import com.espertech.esper.compiler.client.EPCompilerProvider;
import com.espertech.esper.runtime.client.*;

public class Main {
    public static void main(String[] args) throws IOException {
        Configuration configuration = new Configuration();
        configuration.getCommon().addEventType(KursAkcji.class);
        EPRuntime epRuntime = EPRuntimeProvider.getDefaultRuntime(configuration);

        EPDeployment deployment = compileAndDeploy(epRuntime, zapytanie16);

        ProstyListener prostyListener = new ProstyListener();
        for (EPStatement statement : deployment.getStatements()) {
            statement.addListener(prostyListener);
        }

        InputStream inputStream = new InputStream();
        inputStream.generuj(epRuntime.getEventService());
    }

    public static EPDeployment compileAndDeploy(EPRuntime epRuntime, String epl) {
        EPDeploymentService deploymentService = epRuntime.getDeploymentService();
        CompilerArguments args = new CompilerArguments(epRuntime.getConfigurationDeepCopy());
        EPDeployment deployment;
        try {
            EPCompiled epCompiled = EPCompilerProvider.getCompiler().compile(epl, args);
            deployment = deploymentService.deploy(epCompiled);
        } catch (EPCompileException e) {
            throw new RuntimeException(e);
        } catch (EPDeployException e) {
            throw new RuntimeException(e);
        }
        return deployment;
    }


    public static String zapytanie4a =
            "select irstream data, kursZamkniecia, max(kursZamkniecia) " +
            "from KursAkcji(spolka = 'Oracle').win:ext_timed(data.getTime(), 7 days)";
			
    public static String zapytanie4b =
            "select irstream data, kursZamkniecia, max(kursZamkniecia) " +
            "from KursAkcji(spolka = 'Oracle').win:ext_timed_batch(data.getTime(), 7 days)";
			
    public static String zapytanie5 =
            "select istream data, kursZamkniecia, spolka, " +
            "max(kursZamkniecia)-kursZamkniecia as roznica " +
            "from KursAkcji.win:ext_timed_batch(data.getTime(), 1 day)";
			
    public static String zapytanie6 =
            "select istream data, kursZamkniecia, spolka, " +
            "max(kursZamkniecia)-kursZamkniecia as roznica " +
            "from KursAkcji(spolka in ('IBM','Honda','Microsoft')" +
            ".win:ext_timed_batch(data.getTime(), 1 day))";
			
    public static String zapytanie7a =
            "select istream data, kursZamkniecia, spolka, kursOtwarcia " +
            "from KursAkcji(kursZamkniecia-kursOtwarcia>0).win:length(1)";
			
    public static String zapytanie7b =
            "select istream data, kursZamkniecia, spolka, kursOtwarcia " +
            "from KursAkcji(KursAkcji.roznicaKursow(kursOtwarcia, kursZamkniecia)>0).win:length(1)";
			
    public static String zapytanie8 =
            "select istream data, kursZamkniecia, spolka, " +
            "max(kursZamkniecia)-kursZamkniecia as roznica " +
            "from KursAkcji(spolka in ('PepsiCo','CocaCola'))" +
            ".win:ext_timed(data.getTime(), 7 days)";
			
    public static String zapytanie9 =
            "select istream data, kursZamkniecia, spolka " +
            "from KursAkcji(spolka in ('PepsiCo','CocaCola'))" +
            ".win:ext_timed_batch(data.getTime(), 1 day) " +
            "having kursZamkniecia=max(kursZamkniecia)";
			
    public static String zapytanie10 =
            "select max(kursZamkniecia) as maksimum " +
            "from KursAkcji.win:ext_timed_batch(data.getTime(), 7 day)";
			
    public static String zapytanie11 =
            "select istream p.data, p.kursZamkniecia as kursPep, c.kursZamkniecia as kursCoc " +
            "from KursAkcji(spolka='PepsiCo').win:ext_timed(data.getTime(), 1 day) p join " +
            "KursAkcji(spolka='CocaCola').win:ext_timed(data.getTime(), 1 day) c " +
            "on p.data = c.data " +
            "where p.kursZamkniecia-c.kursZamkniecia>0";
			
    public static String zapytanie12 =
            "select istream k.data, k.spolka, k.kursZamkniecia as kursBiezacy, " +
            "k.kursZamkniecia-a.kursZamkniecia as roznica " +
            "from KursAkcji(spolka in ('PepsiCo', 'CocaCola')).win:length(1) k join " +
            "KursAkcji(spolka in ('PepsiCo', 'CocaCola')).std:firstunique(spolka) a " +
            "on k.spolka = a.spolka ";
			
    public static String zapytanie13 =
            "select istream k.data, k.spolka, k.kursZamkniecia as kursBiezacy, " +
            "k.kursZamkniecia-a.kursZamkniecia as roznica " +
            "from KursAkcji.win:length(1) k join " +
            "KursAkcji.std:firstunique(spolka) a " +
            "on k.spolka = a.spolka " +
            "where k.kursZamkniecia > a.kursZamkniecia
			
    public static String zapytanie14 =
            "select istream a.data as dataA, b.data as dataB, a.kursOtwarcia as kursA, " +
            "b.kursOtwarcia as kursB, a.spolka as spolka " +
            "from KursAkcji.win:ext_timed(data.getTime(), 7 days) b join " +
            "KursAkcji.win:ext_timed(data.getTime(), 7 days) a " +
            "on a.spolka = b.spolka " +
            "where b.kursOtwarcia - a.kursOtwarcia > 3";
			
    public static String zapytanie15 =
            "select istream data, spolka, obrot " +
            "from KursAkcji(market = 'NYSE').win:ext_timed_batch(data.getTime(), 7 days) " +
            "order by obrot desc limit 3";
			
    public static String zapytanie16 =
            "select istream data, spolka, obrot " +
            "from KursAkcji(market = 'NYSE').win:ext_timed_batch(data.getTime(), 7 days) " +
            "order by obrot desc limit 2, 1";
}