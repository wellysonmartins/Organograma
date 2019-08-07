/************ ADICIONA O ID DA DIV DE ONDE IRÁ FICAR O ORGANOGRAMA EM UMA VARIÁVEL ********************/
var $organogramaEx = $("#organograma-exemplo"),
    fnShowHide,
    fnOffset,
    fnTamanhoHorizontal;

/************ FUNÇÃO PARA CRIAR O ORGANOGRAMA ********************/
(function createDOM() {
    var ul, li, div, docfrag, i = 0;
    for (var property in jsonOrgan) {
        if (jsonOrgan.hasOwnProperty(property)) {
            /*** FKUnidade é a coluna filho que irá indicar a coluna PAI da tabela ***/
            if (!document.getElementById("ul-" + jsonOrgan[property].FKObjetivoInd)) {
                docfrag = document.createDocumentFragment();
                i++;
                if (jsonOrgan[property].sigla == 'ASJIN') {
                    divZoom = document.createElement("div");
                    divZoom.setAttribute("class", "zoom menos");
                    
                    divBarraHorizontal = document.createElement("div");
                    divBarraHorizontal.setAttribute("class","barrahorizontal");
                    divZoom.appendChild(divBarraHorizontal);

                    divBarraVertical = document.createElement("div");
                    divBarraVertical.setAttribute("class","barravertical");
                    divZoom.appendChild(divBarraVertical);

                    docfrag.appendChild(divZoom)
                }

                if (i > 1 && jsonOrgan[property].sigla != 'ASJIN') {
                    divZoom = document.createElement("div");
                    divZoom.setAttribute("class", "zoom mais");

                    divBarraHorizontal = document.createElement("div");
                    divBarraHorizontal.setAttribute("class","barrahorizontal");
                    divZoom.appendChild(divBarraHorizontal);

                    divBarraVertical = document.createElement("div");
                    divBarraVertical.setAttribute("class","barravertical");
                    divZoom.appendChild(divBarraVertical);

                    docfrag.appendChild(divZoom)
                }

                ul = document.createElement("ul");
                /*** FKObjetivoInd é a coluna filho que irá indicar a coluna PAI da tabela ***/
                ul.setAttribute("id", "ul-" + jsonOrgan[property].FKObjetivoInd);
                ul.setAttribute("class", "hide");
                docfrag.appendChild(ul);
                /*** FKObjetivoInd é a coluna filho que irá indicar a coluna PAI da tabela ***/
                document.getElementById("li-" + jsonOrgan[property].FKObjetivoInd).appendChild(docfrag)
            }

            li = document.createElement("li");
            /*** FKObjetivoDir é a coluna PAI da tabela ***/
            li.setAttribute("id", "li-" + jsonOrgan[property].FKObjetivoDir);
            /*** FKObjetivoInd é a coluna filho que irá indicar a coluna PAI da tabela ***/
            /*** .sigla = COLUNA SIGLA DA TABELA UNIDADE ***/
            /*** .nomeUnidade = COLUNA nomeUnidade DA TABELA UNIDADE ***/
            document.getElementById("ul-" + jsonOrgan[property].FKObjetivoInd).appendChild(li).innerHTML = '<div class="wrap-infos wrap-infos-padrao">' + '<p class="nome">' + jsonOrgan[property].sigla + "</p>" + '<p class="cargo">' + jsonOrgan[property].nomeUnidade + "</p>" + "</div>"
        }
    }
})();

fnTamanhoHorizontal = function () {
    var l = [];
    $organogramaEx
        .css("width", 100000);
    $organogramaEx
        .find("ul")
        .not(".hide")
        .each(function(i) {
            l[i] = $(this).width()
    });
    l.sort(function(a, b) {
        return a - b
    });
    l.pop();
    $organogramaEx
        .css("width", l.pop())
}

fnShowHide = function(element) {
    element
        .toggleClass("mais")
        .toggleClass("menos");
    element
        .siblings("ul")
        .toggleClass("hide");
    $(".hightlight")
        .removeClass("hightlight");
    element
        .prevAll(".wrap-infos")
        .addClass("hightlight");
};

fnOffset = function($btn) {
    var l, t;
    l = $btn
            .prevAll(".wrap-infos")
            .offset()
            .left;
    t = $btn
            .prevAll(".wrap-infos")
            .offset()
            .top;

    setTimeout(function() {
        $(document).scrollLeft(l - $(window).width() / 2 + 60);
        $(document).scrollTop(t)
    }, 25)
};

$organogramaEx.find(".zoom").each(function() {
    var $thisButton = $(this);
    $thisButton.on("click", function() {
        fnShowHide($thisButton);
        fnTamanhoHorizontal();
        fnOffset($thisButton)
    })
});

$("#organograma-infos").find(".zoom").each(function() {
    var $thisButton = $(this);
    $thisButton.on("click", function() {
        fnShowHide($thisButton)
    })
});

$(".organograma li:last-child")
	.addClass("ultimo-filho");
$(".organograma li:only-child")
	.addClass("filho-unico");

$("#ul-1,#ul-2")
	.removeClass("hide");

fnTamanhoHorizontal();