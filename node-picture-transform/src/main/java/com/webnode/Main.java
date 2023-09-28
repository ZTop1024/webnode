package com.webnode;

import cn.hutool.core.img.ImgUtil;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * @author <a href="zhoutuo@wxchina.com">zhoutuo</a>
 * @date 2023/9/27
 **/
public class Main {

    public static void main(String[] args) throws IOException {
        System.out.println("hello world");
        BufferedImage image = ImageIO.read(new File("E:\\future\\webnode\\01.数据库知识体系\\MySQL\\file\\001.Mysql索引知识-图片\\聚束索引.png"));
        String base64 = ImgUtil.toBase64(image, "png");
        System.out.println(base64);
    }

}