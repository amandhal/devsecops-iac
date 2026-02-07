package com.amanzdevsecopsproject;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppTest {

    @Test
    void testBrandHtmlContainsBrand() {
        String h = App.brandHtml();
        assertNotNull(h);
        assertTrue(h.contains("Amanz DecSecOps Project"));
    }

    @Test
    void testBrandHtmlIsNotEmpty() {
        String h = App.brandHtml();
        assertTrue(h.length() > 0);
    }
}