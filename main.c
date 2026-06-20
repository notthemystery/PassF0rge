#include <gtk/gtk.h>

int main(int argc, char *argv[])
{
    gtk_init(&argc, &argv);

    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "My App");
    gtk_window_set_default_size(GTK_WINDOW(window), 450, 300);

    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // ================= MAIN HORIZONTAL LAYOUT =================
    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
    gtk_container_add(GTK_CONTAINER(window), hbox);

    // ================= LEFT ICON =================
    GtkWidget *icon = gtk_image_new_from_file("icon.png");
    gtk_box_pack_start(GTK_BOX(hbox), icon, FALSE, FALSE, 10);

    // ================= RIGHT SIDE =================
    GtkWidget *right = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6);
    gtk_box_pack_start(GTK_BOX(hbox), right, TRUE, TRUE, 10);

    // Title
    GtkWidget *title = gtk_label_new("App Name");
    gtk_box_pack_start(GTK_BOX(right), title, FALSE, FALSE, 0);

    // Description
    GtkWidget *desc = gtk_label_new("Small description here");
    gtk_box_pack_start(GTK_BOX(right), desc, FALSE, FALSE, 0);

    // Username
    GtkWidget *user = gtk_entry_new();
    gtk_entry_set_placeholder_text(GTK_ENTRY(user), "Username");
    gtk_box_pack_start(GTK_BOX(right), user, FALSE, FALSE, 0);

    // Password 1
    GtkWidget *pass1 = gtk_entry_new();
    gtk_entry_set_visibility(GTK_ENTRY(pass1), FALSE);
    gtk_entry_set_placeholder_text(GTK_ENTRY(pass1), "Password");
    gtk_box_pack_start(GTK_BOX(right), pass1, FALSE, FALSE, 0);

    // Password 2
    GtkWidget *pass2 = gtk_entry_new();
    gtk_entry_set_visibility(GTK_ENTRY(pass2), FALSE);
    gtk_entry_set_placeholder_text(GTK_ENTRY(pass2), "Confirm Password");
    gtk_box_pack_start(GTK_BOX(right), pass2, FALSE, FALSE, 0);

    // Status (readonly)
    GtkWidget *status = gtk_entry_new();
    gtk_entry_set_editable(GTK_ENTRY(status), FALSE);
    gtk_entry_set_text(GTK_ENTRY(status), "Status: Ready");
    gtk_box_pack_start(GTK_BOX(right), status, FALSE, FALSE, 0);

    // Button (bottom)
    GtkWidget *btn = gtk_button_new_with_label("Run");
    gtk_box_pack_start(GTK_BOX(right), btn, FALSE, FALSE, 10);

    gtk_widget_show_all(window);

    gtk_main();

    return 0;
}
