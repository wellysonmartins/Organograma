<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="utf-8">
        <link rel="stylesheet" href="stylesheets/main.css">
        <title>Organograma</title>
    </head>

    <body>
        <!-- DIV QUE FICARÁ O ORGANOGRAMA -->
        <div class="main">
            <section id="organograma-exemplo" class="organograma">
                <header class="wrap-titulo-pagina">
                    <h1>Organograma</h1>
                </header>
                <ul id="ul-0" class="organograma-exemplo-base">
                </ul>
            </section>
        </div>
        
        <!-- SCRIPT JQUERY -->
        <script>
            !window.jQuery && document.write('<script src="vendors/jquery-1.11.1.min.js"><\/script>')
        </script>
        
        <!-- IMPORTANDO ARQUIVO PHP COMO RESULTADO DA CONSULTA AO BANCO DE DADOS -->
        <?php include_once('scripts/main02.php'); ?>
        
        <!-- SALVANDO O RESULTADO DA CONSULTA FEITA EM PHP NA VARIÁVEL jsonOrgan DO JAVASCRIPT -->
        <script type="text/javascript">
            var jsonOrgan = <?=$result?>;   
        </script>
        
        <!-- IMPORTANDO ARQUIVO JAVASCRIPT COM O SCRIPT DA MONTAGEM DO ORGANOGRAMA -->
        <script src="scripts/main02.js"></script>
    </body>
</html>
