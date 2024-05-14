package hello.itemservice.web.basic;

import hello.itemservice.domain.item.Item;
import hello.itemservice.domain.item.ItemRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/basic/items")
@RequiredArgsConstructor
public class BasicItemController {

    private final ItemRepository itemRepository;

    @GetMapping
    public String items(Model model){
        List<Item> items = itemRepository.findAll();
        model.addAttribute("items", items);
        return "basic/items";
    }

    @PostConstruct
    public void init(){
        itemRepository.save(new Item("itemA" , 10000, 10));
        itemRepository.save(new Item("itemB" , 20000, 20));
    }

    @GetMapping("/{itemId}")
    public String item(@PathVariable long itemId, Model model){
        Item item = itemRepository.findById(itemId);
        model.addAttribute("item", item);
        return "basic/item";
    }

    @GetMapping("/add")
    public String addForm (){
        return "basic/addForm";
    }
    @PostMapping("/add")
    //public String save (@RequestParam String itemName,
    //                      @RequestParam int price,
    //                      @RequestParam Integer quantity,
    //                      Model model){
    // 직접 Item에 직접 값을 세팅해주고 redirect 없이 /basic/items로 가는 코드
    //public String save (@ModelAttribute("item") Item item
    // model.addAttribute("item", item) 의 기능을 해줌
    public String save (Item item, Model model, RedirectAttributes ra){

        itemRepository.save(item);
        ra.addAttribute("itemId",item.getId());
        ra.addAttribute("status", true);
        return "redirect:/basic/items/{itemId}";
    }

    @GetMapping("/{itemId}/edit")
    public String editForm(@PathVariable long itemId, Model model){
        Item item = itemRepository.findById(itemId);
        model.addAttribute("item", item);
        return "basic/editForm";
    }

    @PostMapping("/{itemId}/edit")
    public String edit(@PathVariable long itemId, Model model, Item item){

        itemRepository.update(itemId, item);
        model.addAttribute("item", item);
        return "redirect:/basic/items/{itemId}";
    }


}
