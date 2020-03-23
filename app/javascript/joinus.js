// リスト部状態更新処理
function updateStatus(atdname, status) {
    list = $('.mbr')
    if(list.length > 0) {
        list.each(function(idx, atd) {
            console.log(atdname + ':' + $(atd).text())
            if($(atd).text().trim() == atdname) {
                $(atd).find('input').val(status);
                console.log( $(atd).find('input').val() )
            }
        });
    }
}


// リスト部マーキング処理
function marking() {
    var list = $('.mbr');
    console.log(list.length);
    if(list.length > 0) {
        list.each(function(idx, mbr){
            var stt = mbr.getElementsByTagName('input')[0].getAttribute('value');
            var bkcolor = (stt == 0 ?  '' : 'rgb(250, 250, 0)');
    //        console.log(bkcolor);
            $(mbr).css('background-color', bkcolor);
        });
    }
  }
  
// 画面表示時: リスト部マーキング
document.addEventListener("DOMContentLoaded", function() {
    if(['member.attend', 'stuff.show', 'mecha.show'].indexOf($('#viewname').val()) >= 0) {
        marking();
    }
});



// メッセージ通知の時: メッセージエリアに表示


// クローズ時: 参加者データを削除する
  
  