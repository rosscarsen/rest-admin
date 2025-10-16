# rest_admin（主档以供应商为模板）

**服务器所有返回数据必须是map类型，key为字段名，value为字段值**

## IOS还配置未完成

- printing: ^5.14.2
- form_builder_file_picker: ^5.0.0

## 获取网页节点下的所有输入框name

``` js
$(document).ready(function(){
    var namesArray = $('.cus-product').find('input:visible, select:visible, textarea:visible').map(function() {
        return $(this).attr('name');
    }).get();
    console.log(namesArray);
})
```
